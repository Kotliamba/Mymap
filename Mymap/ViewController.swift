//
//  ViewController.swift
//  Mymap
//
//  Created by Чаусов Николай on 20.03.2022.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController {
    
    var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()
    
    var annotationArray = [MKPointAnnotation]()
    
    let addAdresButton: UIButton = {
        let button = UIButton()
        button.setTitle("ADD ADRESS", for: .normal)
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        button.layer.backgroundColor = CGColor(red: 250, green: 0, blue: 0, alpha: 1)
        button.layer.cornerRadius = 20
        button.translatesAutoresizingMaskIntoConstraints = false
       
        return button
    }()

    
    let routeButton: UIButton = {
        let button = UIButton()
        button.setTitle("ROUTE", for: .normal)
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        button.layer.backgroundColor = CGColor(red: 250, green: 0, blue: 0, alpha: 1)
        button.layer.cornerRadius = 20
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        return button
    }()
    
    let resetButton: UIButton = {
        let button = UIButton()
        button.setTitle("RESET", for: .normal)
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        button.layer.backgroundColor = CGColor(red: 250, green: 0, blue: 0, alpha: 1)
        button.layer.cornerRadius = 20
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setConstraints()
        //Сэтим IBActions через селекторы
        addAdresButton.addTarget(self, action: #selector(addAdressButtonTapped), for: .touchUpInside)
        routeButton.addTarget(self, action: #selector(routeButtonTapped), for: .touchUpInside)
        resetButton.addTarget(self, action: #selector(resetButtonTapped ), for: .touchUpInside)
        
        mapView.delegate = self

    
    }
    
    @objc func addAdressButtonTapped(){
        alertAddAdress(to: "Добавить", placeholder: "Введите адрес", completionHandler: { [unowned self] text in
            setupPlaceMark(addres: text)
        })
        
    }
    
    @objc func routeButtonTapped(){
        for i in 0...annotationArray.count-2 {
            directionRequest(from: annotationArray[i].coordinate, to: annotationArray[i+1].coordinate)
        }
        
        mapView.showAnnotations(annotationArray, animated: true)
    }
    
    @objc func resetButtonTapped(){
        self.mapView.removeOverlays(mapView.overlays)
        self.mapView.removeAnnotations(mapView.annotations)
        
        annotationArray = [MKPointAnnotation]()
        routeButton.isHidden = true
        resetButton.isHidden = true
    }
    
    private func setupPlaceMark(addres: String){
        //Через geoCoder задаем переводим строку в координаты, ставим плейсмарки на карте
        let geoCoder = CLGeocoder()
        
        geoCoder.geocodeAddressString(addres) { [unowned self] (placemark,error) in
            if let error = error{
                print(error)
                alertError(title: "Server error 404", message: "Bad connection")
                return
            }
            //Возвращаем самую похожую точку
            guard let placemark = placemark else {return}
            let place = placemark.first
            
            let annotation = MKPointAnnotation()
            annotation.title = addres
            
            guard let placemarkLocation = place?.location else {return}
            annotation.coordinate = placemarkLocation.coordinate
            
            annotationArray.append(annotation)
            
            if annotationArray.count == 2 {
                routeButton.isHidden = false
                resetButton.isHidden = false
            }
            
            mapView.showAnnotations(annotationArray, animated: true)
        }
    }
    
    private func directionRequest(from start: CLLocationCoordinate2D, to finish: CLLocationCoordinate2D){
        let startLocation = MKPlacemark(coordinate: start)
        let finishLocation = MKPlacemark(coordinate: finish)
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: startLocation)
        request.destination = MKMapItem(placemark: finishLocation)
        
        request.transportType = .walking
        request.requestsAlternateRoutes = true
        
        
        //Строим маршрут от начальной точки до стартовой, которые запакованы в request
        let direction = MKDirections(request: request)
        direction.calculate { (response, error) in
            if let error = error {
                print(error)
                return
            }
            guard let response = response else {
                self.alertError(title: "Ошибка", message: "Маршрут недоступен")
                return
            }
            //Выбираем оптимальный маршрут по минимальной дистанции
            var minTrace = response.routes[0]
            for trace in response.routes {
                minTrace = (trace.distance < minTrace.distance) ? trace : minTrace
            }
            
            self.mapView.addOverlay(minTrace.polyline)
        }
    }
}

extension ViewController: MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let render = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        render.strokeColor = .blue
        return render
    }
}

extension ViewController {
    func setConstraints() {
        view.addSubview(mapView)
        NSLayoutConstraint.activate([
            
            
            mapView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            
        
        ])
        
        mapView.addSubview(addAdresButton)
        NSLayoutConstraint.activate([
            addAdresButton.topAnchor.constraint(equalTo: mapView.topAnchor, constant: 20),
            addAdresButton.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -20),
            addAdresButton.heightAnchor.constraint(equalToConstant: 70),
            addAdresButton.widthAnchor.constraint(equalToConstant: 110)
        ])
        
        mapView.addSubview(routeButton)
        NSLayoutConstraint.activate([
            routeButton.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: -20),
            routeButton.leadingAnchor.constraint(equalTo: mapView.leadingAnchor, constant: 20),
            routeButton.heightAnchor.constraint(equalToConstant: 70),
            routeButton.widthAnchor.constraint(equalToConstant: 110)
        ])

        mapView.addSubview(resetButton)
        NSLayoutConstraint.activate([
            resetButton.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: -20),
            resetButton.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -20),
            resetButton.heightAnchor.constraint(equalToConstant: 70),
            resetButton.widthAnchor.constraint(equalToConstant: 110)
        ])
    }
}

