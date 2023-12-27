// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:_private_core/_private_core.dart';
import 'package:_private_core/widgets/widgets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:temp_package_name/src/base/main/bloc/main_bloc.dart';
import 'package:temp_package_name/src/utils/app_map_helper.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'package:temp_package_name/src/constants/constants.dart';

class WidgetAppMap extends StatefulWidget {
  static LatLng get defaultLatLng => mainBloc.currentLocation.value != null
      ? LatLng(mainBloc.currentLocation.value!.latitude,
          mainBloc.currentLocation.value!.longitude)
      : getCenterPointByCountryCode();

  final BorderRadius? borderRadius;
  final Function(GoogleMapController)? controllerInitialized;
  final List<Marker>? markers;
  final double zoom;
  final double minZoom;
  final double maxZoom;
  final LatLng center;
  final Widget Function(Widget)? controllerBuilder;
  final List<AppBuildMarker>? buildMarkers;

  final CameraPositionCallback? onCameraMove;

  final bool enableControllerHome;
  final bool enableControllerCurrentPosition;
  const WidgetAppMap({
    super.key,
    this.borderRadius,
    this.controllerInitialized,
    this.markers,
    required this.center,
    this.controllerBuilder,
    this.zoom = 3,
    this.minZoom = 4,
    this.maxZoom = 21,
    this.enableControllerHome = true,
    this.enableControllerCurrentPosition = true,
    this.buildMarkers,
    this.onCameraMove,
  });

  @override
  State<WidgetAppMap> createState() => _WidgetAppMapState();
}

class _WidgetAppMapState extends State<WidgetAppMap> {
  final bool _compassEnabled = true;
  final bool _mapToolbarEnabled = true;
  final CameraTargetBounds _cameraTargetBounds = CameraTargetBounds.unbounded;
  late final MinMaxZoomPreference _minMaxZoomPreference =
      MinMaxZoomPreference(widget.minZoom, widget.maxZoom);
  final MapType _mapType = MapType.normal;
  final bool _rotateGesturesEnabled = true;
  final bool _scrollGesturesEnabled = true;
  final bool _tiltGesturesEnabled = true;
  final bool _zoomControlsEnabled = false;
  final bool _zoomGesturesEnabled = true;
  final bool _indoorViewEnabled = true;
  final bool _myLocationEnabled = true;
  final bool _myTrafficEnabled = false;
  final bool _myLocationButtonEnabled = true;
  late GoogleMapController mapController;

  List<Marker> markers = [];

  _generateMarkers() async {
    markers.clear();
    if (mounted) setState(() {});
    // if (currentLocation != null) {
    //   var icon = await const _WidgetMarker()
    //       .toBitmapDescriptor(devicePixelRatio: 1.35);
    //   markers.add(Marker(
    //     icon: icon,
    //     position: LatLng(currentLocation!.latitude, currentLocation!.longitude),
    //     markerId: const MarkerId('marker-currentLocation'),
    //   ));
    // }
    if (widget.buildMarkers?.isNotEmpty == true) {
      for (var e in widget.buildMarkers!) {
        late BitmapDescriptor icon;
        if (AppMapHelper.localBitmapDescriptors[e.id] != null) {
          icon = AppMapHelper.localBitmapDescriptors[e.id]!;
        } else {
          if (e.widget != null) {
            icon = await e.widget!.toBitmapDescriptor(
                waitToRenderDuration: const Duration(milliseconds: 500),
                devicePixelRatio: 1.0,
                imageUrls: e.imageUrls);
          } else {
            icon = await e.builder!();
          }
          AppMapHelper.localBitmapDescriptors[e.id] = icon;
        }
        if (widget.buildMarkers!.any((e0) => e.id == e0.id)) {
          markers.add(Marker(
            icon: icon,
            position: e.latLng,
            markerId: MarkerId('marker-${e.id}'),
            onTap: e.onTap,
          ));
        }
        // if (mounted) setState(() {});
      }
    }
    if (mounted) setState(() {});
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _generateMarkers();
  }

  @override
  void didUpdateWidget(covariant WidgetAppMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    _generateMarkers();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.sw),
      child: LayoutBuilder(builder: (context, p) {
        mapSize = Size(p.maxWidth, p.maxHeight);
        return Stack(
          alignment: Alignment.bottomRight,
          children: [
            GoogleMap(
              markers: ((widget.markers ?? []) + markers).toSet(),
              onMapCreated: onMapCreated,
              initialCameraPosition: CameraPosition(
                target: widget.center,
                zoom: widget.zoom,
              ),
              compassEnabled: _compassEnabled,
              mapToolbarEnabled: _mapToolbarEnabled,
              cameraTargetBounds: _cameraTargetBounds,
              minMaxZoomPreference: _minMaxZoomPreference,
              mapType: _mapType,
              rotateGesturesEnabled: _rotateGesturesEnabled,
              scrollGesturesEnabled: _scrollGesturesEnabled,
              tiltGesturesEnabled: _tiltGesturesEnabled,
              zoomGesturesEnabled: _zoomGesturesEnabled,
              zoomControlsEnabled: _zoomControlsEnabled,
              indoorViewEnabled: _indoorViewEnabled,
              myLocationEnabled: _myLocationEnabled,
              myLocationButtonEnabled: _myLocationButtonEnabled,
              trafficEnabled: _myTrafficEnabled,
              gestureRecognizers: {
                Factory<OneSequenceGestureRecognizer>(
                    () => EagerGestureRecognizer()),
                Factory<PanGestureRecognizer>(() => PanGestureRecognizer()),
                Factory<VerticalDragGestureRecognizer>(
                    () => VerticalDragGestureRecognizer()),
                Factory<HorizontalDragGestureRecognizer>(
                    () => HorizontalDragGestureRecognizer()),
                Factory<ScaleGestureRecognizer>(() => ScaleGestureRecognizer())
              },
              webGestureHandling: WebGestureHandling.cooperative,
              cloudMapId:
                  // AppPrefs.instance.isDarkThemeMode
                  //     ? "86045ad713befcb2" :
                  "475242d24e1f473e",
              onCameraMove: widget.onCameraMove,
            ),
            if (widget.controllerBuilder != null)
              widget.controllerBuilder!(_controller())
            else
              Padding(
                padding: EdgeInsets.all(24.sw),
                child: _controller(),
              ),
          ],
        );
      }),
    );
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
    if (mounted) {
      setState(() {});
      widget.controllerInitialized?.call(mapController);
      _generateMarkers();
    }
  }

  Size? mapSize;
  Position? currentLocation;
  bool fetchingLocation = false;
  void _getCurrentPosition() async {
    if (mounted) {
      setState(() {
        fetchingLocation = true;
      });
      Future a() async {
        await Future.delayed(const Duration(seconds: 3));
      }

      Future b() async {
        currentLocation = kDebugMode
            ? Position.fromMap({"latitude": 50.846979, "longitude": 4.358062})
            : await Geolocator.getCurrentPosition(
                desiredAccuracy: LocationAccuracy.high);
      }

      await Future.wait([a(), b()]);

      await _generateMarkers();

      if (markers.isNotEmpty) {
        updateMapToBounds(
          markers,
          mapController,
          mapSize: mapSize,
        );
      }

      fetchingLocation = false;
      if (mounted) {
        setState(() {});
      }
    }
  }

  void moveToCenter() async {
    mapController.animateCamera(CameraUpdate.newLatLngZoom(
        widget.center, await mapController.getZoomLevel() + .5));
  }

  Widget _controller() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.enableControllerCurrentPosition) ...[
          _buildGlass(
            child: AnimatedSize(
              duration: const Duration(milliseconds: 300),
              child: fetchingLocation
                  ? SizedBox(
                      height: 48.sw,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          WidgetAppLottie(
                            assetlottie('searchPosition'),
                            width: 36.sw,
                          ),
                          SizedBox(
                            width: 4.sw,
                          ),
                          Text(
                            'searching\nyour position'.tr(),
                            style: w300TextStyle(fontSize: fs14(context)),
                          ),
                          SizedBox(
                            width: 8.sw,
                          ),
                        ],
                      ),
                    )
                  : _buildButton(
                      icon: 'locateMe',
                      onTap: _getCurrentPosition,
                    ),
            ),
          ),
          SizedBox(
            height: 8.sw,
          )
        ],
        _buildGlass(
          child: Column(
            children: [
              _buildButton(
                  icon: 'ic_map_zoomout',
                  onTap: () {
                    mapController.animateCamera(CameraUpdate.zoomOut());
                  }),
              SizedBox(
                height: 4.sw,
              ),
              _buildButton(
                  icon: 'ic_map_zoomin',
                  onTap: () async {
                    mapController.animateCamera(CameraUpdate.zoomIn());
                  }),
            ],
          ),
        ),
        if (widget.enableControllerHome) ...[
          SizedBox(
            height: 8.sw,
          ),
          _buildGlass(
            child: _buildButton(
              icon: 'locateHome',
              onTap: moveToCenter,
            ),
          ),
        ]
      ],
    );
  }

  Widget _buildGlass({required child}) {
    return WidgetGlassBackground(
      borderRadius: BorderRadius.circular(16.sw),
      backgroundColor: Colors.white24,
      padding: EdgeInsets.all(6.sw),
      child: child,
    );
  }

  Widget _buildButton({required icon, required onTap}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.sw),
        child: Ink(
          width: 42.sw,
          height: 42.sw,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: AppColors.instance.borderGray1),
            borderRadius: BorderRadius.circular(16.sw),
          ),
          child: Center(
            child: WidgetAppSVG(
              assetsvg(icon),
              width: 24.sw,
              height: 24.sw,
            ),
          ),
        ),
      ),
    );
  }
}

class WidgetAppOpenStreetMap extends StatelessWidget {
  final dynamic lat;
  final dynamic lng;
  final String? googleStreetMapUrl;
  const WidgetAppOpenStreetMap(
      {super.key,
      required this.lat,
      required this.lng,
      this.googleStreetMapUrl});

  @override
  Widget build(BuildContext context) {
    return WidgetGlassBackground(
      borderRadius: BorderRadius.circular(12.sw),
      backgroundColor: Colors.white24,
      padding: EdgeInsets.all(6.sw),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            launchUrlString(googleStreetMapUrl ??
                'http://maps.google.com/maps?q=&layer=c&cbll=$lat,$lng&cbp=');
          },
          borderRadius: BorderRadius.circular(8.sw),
          child: Ink(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: AppColors.instance.borderGray1),
              borderRadius: BorderRadius.circular(8.sw),
            ),
            padding: EdgeInsets.symmetric(vertical: 8.sw, horizontal: 16.sw),
            child: Center(
              child: Text(
                'Open street view'.tr(),
                style: w300TextStyle(
                    fontSize: fs16(context), color: AppColors.instance.gray1),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

LatLng getCenterPointByCountryCode([String? code]) {
  switch ((code ?? mainBloc.currentCountryCode).toUpperCase()) {
    case 'AF':
      return const LatLng(34.5553, 69.2075); // Kabul, Afghanistan
    case 'AL':
      return const LatLng(41.3275, 19.8187); // Tirana, Albania
    case 'DZ':
      return const LatLng(36.7528, 3.0420); // Algiers, Algeria
    case 'AD':
      return const LatLng(42.5063, 1.5218); // Andorra la Vella, Andorra
    case 'AO':
      return const LatLng(-8.8135, 13.2420); // Luanda, Angola
    case 'AR':
      return const LatLng(-34.6118, -58.4173); // Buenos Aires, Argentina
    case 'AM':
      return const LatLng(40.1872, 44.5152); // Yerevan, Armenia
    case 'AU':
      return const LatLng(-35.2820, 149.1287); // Canberra, Australia
    case 'AT':
      return const LatLng(48.2100, 16.3636); // Vienna, Austria
    case 'AZ':
      return const LatLng(40.3834, 49.8932); // Baku, Azerbaijan
    case 'BH':
      return const LatLng(26.1921, 50.5354); // Manama, Bahrain
    case 'BD':
      return const LatLng(23.8103, 90.4125); // Dhaka, Bangladesh
    case 'BY':
      return const LatLng(53.8930, 27.5675); // Minsk, Belarus
    case 'BE':
      return const LatLng(50.8503, 4.3517); // Brussels, Belgium
    case 'BZ':
      return const LatLng(17.2500, -88.7667); // Belmopan, Belize
    case 'BJ':
      return const LatLng(6.3528, 2.4200); // Porto-Novo, Benin
    case 'BT':
      return const LatLng(27.4728, 89.6393); // Thimphu, Bhutan
    case 'BO':
      return const LatLng(-16.5000, -68.1500); // La Paz, Bolivia
    case 'BA':
      return const LatLng(43.8563, 18.4131); // Sarajevo, Bosnia and Herzegovina
    case 'BR':
      return const LatLng(-15.7801, -47.9292); // Brasília, Brazil
    case 'BN':
      return const LatLng(4.9419, 114.9481); // Bandar Seri Begawan, Brunei
    case 'BG':
      return const LatLng(42.6977, 23.3219); // Sofia, Bulgaria
    case 'BF':
      return const LatLng(12.3714, -1.5197); // Ouagadougou, Burkina Faso
    case 'BI':
      return const LatLng(-3.3731, 29.9189); // Bujumbura, Burundi
    case 'KH':
      return const LatLng(11.5449, 104.8922); // Phnom Penh, Cambodia
    case 'CM':
      return const LatLng(3.8480, 11.5021); // Yaoundé, Cameroon
    case 'CA':
      return const LatLng(45.4215, -75.6994); // Ottawa, Canada
    case 'CF':
      return const LatLng(4.3947, 18.5582); // Bangui, Central African Republic
    case 'TD':
      return const LatLng(12.1348, 15.0557); // N'Djamena, Chad
    case 'CL':
      return const LatLng(-33.4691, -70.6420); // Santiago, Chile
    case 'CN':
      return const LatLng(39.9042, 116.4074); // Beijing, China
    case 'CO':
      return const LatLng(4.7110, -74.0721); // Bogotá, Colombia
    case 'KM':
      return const LatLng(-11.8750, 43.8722); // Moroni, Comoros
    case 'CR':
      return const LatLng(9.9350, -84.0841); // San Jose, Costa Rica
    case 'HR':
      return const LatLng(45.8150, 15.9819); // Zagreb, Croatia
    case 'CU':
      return const LatLng(23.1136, -82.3666); // Havana, Cuba
    case 'CY':
      return const LatLng(35.1676, 33.3736); // Nicosia, Cyprus
    case 'CZ':
      return const LatLng(50.0755, 14.4378); // Prague, Czech Republic
    case 'CD':
      return const LatLng(
          -4.0383, 21.7587); // Kinshasa, Democratic Republic of the Congo
    case 'DK':
      return const LatLng(55.6761, 12.5683); // Copenhagen, Denmark
    case 'DJ':
      return const LatLng(11.6090, 43.1479); // Djibouti, Djibouti
    case 'DM':
      return const LatLng(15.2993, -61.3876); // Roseau, Dominica
    case 'DO':
      return const LatLng(
          18.4744, -69.8908); // Santo Domingo, Dominican Republic
    case 'TL':
      return const LatLng(-8.8742, 125.7275); // Dili, East Timor
    case 'EC':
      return const LatLng(-0.2295, -78.5243); // Quito, Ecuador
    case 'EG':
      return const LatLng(30.0444, 31.2357); // Cairo, Egypt
    case 'SV':
      return const LatLng(13.6929, -89.2182); // San Salvador, El Salvador
    case 'GQ':
      return const LatLng(3.8480, 11.5021); // Malabo, Equatorial Guinea
    case 'ER':
      return const LatLng(15.3229, 38.9250); // Asmara, Eritrea
    case 'EE':
      return const LatLng(59.4370, 24.7536); // Tallinn, Estonia
    case 'ET':
      return const LatLng(9.1450, 40.4897); // Addis Ababa, Ethiopia
    case 'FJ':
      return const LatLng(-18.1248, 178.4500); // Suva, Fiji
    case 'FI':
      return const LatLng(60.1695, 24.9354); // Helsinki, Finland
    case 'FR':
      return const LatLng(48.8566, 2.3522); // Paris, France
    case 'GA':
      return const LatLng(-0.8037, 11.6094); // Libreville, Gabon
    case 'GM':
      return const LatLng(13.4549, -16.5790); // Banjul, Gambia
    case 'GE':
      return const LatLng(41.7151, 44.8271); // Tbilisi, Georgia
    case 'DE':
      return const LatLng(51.1657, 10.4515); // Berlin, Germany
    case 'GH':
      return const LatLng(5.6037, -0.1870); // Accra, Ghana
    case 'GR':
      return const LatLng(37.9838, 23.7275); // Athens, Greece
    case 'GD':
      return const LatLng(12.0567, -61.7480); // St. George's, Grenada
    case 'GT':
      return const LatLng(14.6345, -90.5069); // Guatemala City, Guatemala
    case 'GN':
      return const LatLng(9.1450, -13.2000); // Conakry, Guinea
    case 'GW':
      return const LatLng(11.8037, -15.1804); // Bissau, Guinea-Bissau
    case 'GY':
      return const LatLng(6.8046, -58.1551); // Georgetown, Guyana
    case 'HT':
      return const LatLng(18.5944, -72.3074); // Port-au-Prince, Haiti
    case 'HN':
      return const LatLng(14.6345, -87.6100); // Tegucigalpa, Honduras
    case 'HU':
      return const LatLng(47.4979, 19.0402); // Budapest, Hungary
    case 'IS':
      return const LatLng(64.1466, -21.9426); // Reykjavik, Iceland
    case 'IN':
      return const LatLng(28.6139, 77.2090); // New Delhi, India
    case 'ID':
      return const LatLng(-6.2088, 106.8456); // Jakarta, Indonesia
    case 'IR':
      return const LatLng(35.6895, 51.3962); // Tehran, Iran
    case 'IQ':
      return const LatLng(33.3152, 44.3661); // Baghdad, Iraq
    case 'IE':
      return const LatLng(53.3498, -6.2603); // Dublin, Ireland
    case 'IL':
      return const LatLng(31.7683, 35.2137); // Jerusalem, Israel
    case 'IT':
      return const LatLng(41.9028, 12.4964); // Rome, Italy
    case 'JM':
      return const LatLng(18.0188, -76.8015); // Kingston, Jamaica
    case 'JP':
      return const LatLng(35.6895, 139.6917); // Tokyo, Japan
    case 'JO':
      return const LatLng(31.5497, 35.6532); // Amman, Jordan
    case 'KZ':
      return const LatLng(51.1694, 71.4491); // Nur-Sultan, Kazakhstan
    case 'KE':
      return const LatLng(-1.2864, 36.8172); // Nairobi, Kenya
    case 'KI':
      return const LatLng(-3.3704, -168.7340); // South Tarawa, Kiribati
    case 'KP':
      return const LatLng(39.0392, 125.7625); // Pyongyang, North Korea
    case 'KR':
      return const LatLng(37.5665, 126.9780); // Seoul, South Korea
    case 'KW':
      return const LatLng(29.3759, 47.9774); // Kuwait City, Kuwait
    case 'KG':
      return const LatLng(42.8746, 74.5698); // Bishkek, Kyrgyzstan
    case 'LA':
      return const LatLng(17.9757, 102.6331); // Vientiane, Laos
    case 'LV':
      return const LatLng(56.9496, 24.1052); // Riga, Latvia
    case 'LB':
      return const LatLng(33.8886, 35.4955); // Beirut, Lebanon
    case 'LS':
      return const LatLng(-29.6099, 28.2335); // Maseru, Lesotho
    case 'LR':
      return const LatLng(6.3000, -10.7833); // Monrovia, Liberia
    case 'LY':
      return const LatLng(32.8872, 13.1913); // Tripoli, Libya
    case 'LI':
      return const LatLng(47.1660, 9.5554); // Vaduz, Liechtenstein
    case 'LT':
      return const LatLng(54.6896, 25.2799); // Vilnius, Lithuania
    case 'LU':
      return const LatLng(49.6117, 6.1319); // Luxembourg City, Luxembourg
    case 'MK':
      return const LatLng(42.0039, 21.4270); // Skopje, North Macedonia
    case 'MG':
      return const LatLng(-18.8792, 47.5079); // Antananarivo, Madagascar
    case 'MW':
      return const LatLng(-13.9632, 33.7741); // Lilongwe, Malawi
    case 'MY':
      return const LatLng(3.1390, 101.6869); // Kuala Lumpur, Malaysia
    case 'MV':
      return const LatLng(4.1913, 73.5093); // Malé, Maldives
    case 'ML':
      return const LatLng(12.6392, -8.0029); // Bamako, Mali
    case 'MT':
      return const LatLng(35.8989, 14.5146); // Valletta, Malta
    case 'MH':
      return const LatLng(7.1315, 171.1845); // Majuro, Marshall Islands
    case 'MR':
      return const LatLng(18.0660, -15.9785); // Nouakchott, Mauritania
    case 'MU':
      return const LatLng(-20.3484, 57.5522); // Port Louis, Mauritius
    case 'MX':
      return const LatLng(19.4326, -99.1332); // Mexico City, Mexico
    case 'FM':
      return const LatLng(6.9248, 158.1610); // Palikir, Micrones
    case 'CH':
      return const LatLng(46.9480, 7.4474);
    case 'ES':
      return const LatLng(40.4168, -3.7038);
    case 'GB':
      return const LatLng(51.5074, -0.1278);
    case 'NL':
      return const LatLng(52.3702, 4.8952);
    case 'PT':
      return const LatLng(38.7223, -9.1393);
    case 'RS':
      return const LatLng(44.7866, 20.4489);
    case 'SI':
      return const LatLng(46.0569, 14.5058);
    case 'TR':
      return const LatLng(39.9334, 32.8597);
    case 'VN':
      return const LatLng(21.0285, 105.8542);
  }
  //'BE'
  return const LatLng(50.846979, 4.358062);
}

class AppBuildMarker {
  Function() onTap;
  Widget? widget;
  LatLng latLng;
  String id;
  List<String?>? imageUrls;
  Future<BitmapDescriptor> Function()? builder;

  AppBuildMarker({
    required this.id,
    required this.onTap,
    required this.widget,
    required this.latLng,
    this.imageUrls,
  }) : builder = null;

  AppBuildMarker.builder({
    required this.id,
    required this.onTap,
    required this.latLng,
    required this.builder,
  }) : widget = null;
}
