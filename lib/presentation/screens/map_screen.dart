import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maptest/data/models/placeDirection.dart';
import 'package:maptest/presentation/widgets/distanceTime.dart';
import 'package:uuid/uuid.dart';
import '../../data/models/placeDetail.dart';
import '../../data/models/placeSuggestion.dart';
import '../../business_logic/cubit/google_map/google_map_cubit.dart';
import '../../constants/colors.dart';
import '../../helpers/location_helper.dart';
import '../widgets/my_drawer.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';

import '../../constants/string.dart';
import '../widgets/placeItem.dart';

class MapScreen extends StatefulWidget {
  MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  List<PlaceSuggestion> places = [];

  Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();

  FloatingSearchBarController controller = FloatingSearchBarController();

  static Position? position;
// these variable for getSearchedLocation
  Set<Marker> matkers = Set();
  late PlaceSuggestion placeSuggestion;
  late PlaceDetail selectedPlaceDetail;
  late Marker searchedPlaceMarker;
  late Marker currentPlaceMarker;
  late CameraPosition goToSearchForPlace;

// these variable for getDirection

  PlaceDirection? placeDirection;
  bool progresseIndicator = false;
  List<LatLng>? polylinePoints;
  bool isSearchedPlaceMarkerClicked = false;
  bool isDistanceTimeVisible = false;
  late String time;
  late String distance;

  void buildCameraNewPlace() {
    goToSearchForPlace = CameraPosition(
      bearing: 0.0,
      tilt: 0.0,
      target: LatLng(selectedPlaceDetail.lat!, selectedPlaceDetail.lng!),
      zoom: 13,
    );
  }

  void getSelectedPlaceDetail() {
    final sessionToken = const Uuid().v4();
    BlocProvider.of<GoogleMapCubit>(context)
        .getPlaceDetail(placeSuggestion.palceId!, sessionToken);
  }

  static final CameraPosition _myCurrentLocationCameraPosition = CameraPosition(
    bearing: 0.0,
    target: LatLng(position!.latitude, position!.longitude),
    tilt: 0.0,
    zoom: 17,
  );

  Widget buildSelectedPlaceDetailBloc() {
    return BlocListener<GoogleMapCubit, GoogleMapState>(
      listener: ((context, state) {
        if (state is PlaceDetailLoaded) {
          selectedPlaceDetail = state.placeDetail;
          goToMySearchedForLocation();
          getDirection();
        }
      }),
      child: Container(),
    );
  }

  void getDirection() {
    BlocProvider.of<GoogleMapCubit>(context).getPlaceDirection(
        _myCurrentLocationCameraPosition.target, goToSearchForPlace.target);
  }

  Widget buildDirectionBloc() {
    return BlocListener<GoogleMapCubit, GoogleMapState>(
      listener: ((context, state) {
        if (state is PlaceDirectionLoaded) {
          placeDirection = state.placeDirection;

          getPolylinePoints();
        }
      }),
      child: Container(),
    );
  }

  void getPolylinePoints() {
    polylinePoints = placeDirection!.polylinePoint
        .map((e) => LatLng(e.latitude, e.longitude))
        .toList();
  }

  Future<void> goToMySearchedForLocation() async {
    buildCameraNewPlace();
    final GoogleMapController controller = await _mapController.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(goToSearchForPlace),
    );
    buildSearchedPlaceMarker();
  }

  void buildSearchedPlaceMarker() {
    searchedPlaceMarker = Marker(
      position: goToSearchForPlace.target,
      markerId: const MarkerId('2'),
      onTap: () {
        buildCurrentLocationMarker();
        setState(() {
          isSearchedPlaceMarkerClicked = true;
          isDistanceTimeVisible = true;
        });
      },
      infoWindow: InfoWindow(title: "${placeSuggestion.description}"),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );
    addMarkertoMarkersUpdateUi(searchedPlaceMarker);
  }

  void buildCurrentLocationMarker() {
    currentPlaceMarker = Marker(
      position: _myCurrentLocationCameraPosition.target,
      markerId: const MarkerId('1'),
      infoWindow: const InfoWindow(title: "My current location"),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );
    addMarkertoMarkersUpdateUi(currentPlaceMarker);
  }

  void addMarkertoMarkersUpdateUi(Marker marker) {
    setState(() {
      matkers.add(marker);
    });
  }

  Future<void> getMyCurrentLocation() async {
    position = await LocationHelper.getCurrentLocation().whenComplete(() {
      setState(() {});
    });
  }

  Future<void> _goToMyCurrentLocation() async {
    final GoogleMapController controller = await _mapController.future;
    controller.animateCamera(
        CameraUpdate.newCameraPosition(_myCurrentLocationCameraPosition));
  }

  Widget buildMap() {
    return GoogleMap(
      mapType: MapType.normal,
      myLocationEnabled: true,
      zoomControlsEnabled: false,
      markers: matkers,
      myLocationButtonEnabled: false,
      initialCameraPosition: _myCurrentLocationCameraPosition,
      onMapCreated: (controller) {
        _mapController.complete(controller);
      },
      polylines: polylinePoints != null
          ? {
              Polyline(
                polylineId: const PolylineId('direction'),
                color: Colors.blue,
                width: 5,
                points: polylinePoints!,
              ),
            }
          : {},
    );
  }

  Widget buildFloatingSearchBar() {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return FloatingSearchBar(
      // key: UniqueKey(),
      controller: controller,
      elevation: 6,
      hintStyle: TextStyle(fontSize: 18, color: Colors.grey[500]),
      queryStyle: const TextStyle(fontSize: 18),
      hint: 'Find a place ...',
      border: const BorderSide(style: BorderStyle.none),
      margins: const EdgeInsets.fromLTRB(20, 70, 20, 0),
      padding: const EdgeInsets.symmetric(horizontal: 2),
      height: 52,
      iconColor: MyColors.blue,
      scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
      transitionDuration: const Duration(milliseconds: 600),
      transitionCurve: Curves.easeInOut,
      physics: const BouncingScrollPhysics(),
      axisAlignment: isPortrait ? 0.0 : -1.0,
      openAxisAlignment: 0.0,
      width: isPortrait ? 600 : 500,
      debounceDelay: const Duration(milliseconds: 500),
      progress: progresseIndicator,
      onQueryChanged: (query) {
        getPlacesSuggestions(query);
      },
      onFocusChanged: (isFocused) {
        setState(() {
          isDistanceTimeVisible = false;
        });
      },
      transition: CircularFloatingSearchBarTransition(),
      actions: [
        FloatingSearchBarAction(
          showIfOpened: false,
          child: CircularButton(
            icon: Icon(
              Icons.place,
              color: Colors.black.withOpacity(.6),
            ),
            onPressed: () {},
          ),
        )
      ],
      builder: ((context, transition) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              buildSuggestionBloc(),
              buildSelectedPlaceDetailBloc(),
              buildDirectionBloc(),
            ],
          ),
        );
      }),
    );
  }

  void getPlacesSuggestions(String query) {
    final sessionToken = const Uuid().v4();
    BlocProvider.of<GoogleMapCubit>(context)
        .getAllPlaceSuggestion(query, sessionToken);
  }

  Widget buildSuggestionBloc() {
    return BlocBuilder<GoogleMapCubit, GoogleMapState>(
      builder: (context, state) {
        if (state is GoogleMapLoaded) {
          places = state.places;
          if (places.isNotEmpty) {
            return buildPlacesList();
          } else {
            return Container();
          }
        } else {
          return Container();
        }
      },
    );
  }

  Widget buildPlacesList() {
    return ListView.builder(
      itemCount: places.length,
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      itemBuilder: ((context, index) {
        return InkWell(
          onTap: () {
            placeSuggestion = places[index];
            controller.close();
            polylinePoints == null ? null : polylinePoints!.clear();
            removeAllMarkerUpfateUi();
            getSelectedPlaceDetail();
          },
          child: PlaceItem(
            placeSuggestion: places[index],
          ),
        );
      }),
    );
  }

  void removeAllMarkerUpfateUi() {
    setState(() {
      matkers.clear();
    });
  }

  @override
  void initState() {
    getMyCurrentLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: _goToMyCurrentLocation,
        backgroundColor: MyColors.blue,
        child: const Icon(
          Icons.place,
          color: Colors.white,
        ),
      ),
      body: Stack(
        // fit: StackFit.expand,
        children: [
          position != null
              ? buildMap()
              : const Center(
                  child: CircularProgressIndicator.adaptive(
                    valueColor: AlwaysStoppedAnimation<Color>(MyColors.blue),
                  ),
                ),
          buildFloatingSearchBar(),
          isSearchedPlaceMarkerClicked
              ? DistanceTime(
                  isDistanceTimeVisible: isDistanceTimeVisible,
                  placeDirection: placeDirection,
                )
              : Container(),
          // buildDirectionBloc(),
          // buildSelectedPlaceDetailBloc()
        ],
      ),
    );
  }
}
