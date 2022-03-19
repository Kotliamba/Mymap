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
        addAdresButton.addTarget(self, action: #selector(addAdressButtonTapped), for: .touchUpInside)
        routeButton.addTarget(self, action: #selector(routeButtonTapped), for: .touchUpInside)
        resetButton.addTarget(self, action: #selector(resetButtonTapped ), for: .touchUpInside)
    
    }
    
    @objc func addAdressButtonTapped(){
        alertAddAdress(to: "Добавить", placeholder: "Введите адрес", completionHandler: { text in
            print(text)            
        })
    }
    
    @objc func routeButtonTapped(){
        print("tap ROUTE")
    }
    
    @objc func resetButtonTapped(){
        print("tap RESET")
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

