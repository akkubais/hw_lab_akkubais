import SwiftUI
import MapKit

struct MapView: View {
    var locationManager: LocationManager
    @State private var position: MapCameraPosition = .automatic

    private var car: CarLocation {
        CarLocation(coordinate: CLLocationCoordinate2D(
            latitude: locationManager.coordinate.latitude,
            longitude: locationManager.coordinate.longitude),
                    title: "Your Car is Here", subtitle: "Your Car")
    }

    var body: some View {
        Map(position: $position) {
            UserAnnotation()
            if locationManager.coordinate.hasLocation {
                Annotation(car.title, coordinate: car.coordinate) {
                    VStack(spacing: 4) {
                        Image(systemName: "car.fill").font(.title).foregroundStyle(.red)
                            .padding(8).background(.white, in: Circle()).shadow(radius: 3)
                        Text(car.subtitle).font(.caption).foregroundStyle(.black)
                            .padding(4).background(.white.opacity(0.9), in: RoundedRectangle(cornerRadius: 4))
                    }
                    .accessibilityLabel("Your parked car")
                }.annotationTitles(.hidden)
            }
        }
        .mapControls { MapUserLocationButton(); MapCompass(); MapScaleView() }
        .safeAreaInset(edge: .top, alignment: .leading) {
            if locationManager.coordinate.hasLocation {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Your Car Location").font(.headline)
                    Text("Lat: \(String(format: "%.6f", car.coordinate.latitude))").font(.caption)
                    Text("Lon: \(String(format: "%.6f", car.coordinate.longitude))").font(.caption)
                }
                .padding().background(.regularMaterial, in: RoundedRectangle(cornerRadius: 10))
                .padding()
            }
        }
        .navigationTitle("Map View")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: updateMapPosition)
        .onChange(of: locationManager.coordinate) { _, _ in updateMapPosition() }
    }

    /// Centers the camera on the parked car while leaving the map freely pannable.
    private func updateMapPosition() {
        guard locationManager.coordinate.hasLocation else { return }
        position = .region(MKCoordinateRegion(center: car.coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)))
    }
}
