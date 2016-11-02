//
//  ViewController.swift
//  Filterer
//
//  Created by Jack on 2015-09-22.
//  Copyright © 2015 UofT. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    //MARK: Outlets
    @IBOutlet var originalImageView: UIImageView!
    @IBOutlet weak var filteredImageView: UIImageView!
    @IBOutlet var filterMenu: UIView!
    @IBOutlet var instensitySliderView: UIView!
    @IBOutlet var bottomMenu: UIView!
    @IBOutlet var filterButton: UIButton!
    @IBOutlet weak var compareButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var originalImageLabel: UILabel!
    @IBOutlet weak var minimumSliderValueLabel: UILabel!
    @IBOutlet weak var maximumSliderValueLabel: UILabel!
    @IBOutlet weak var intensitySlider: UISlider!
    @IBOutlet weak var toggleButton: UIButton!
    
    //MARK: Private Properties
    fileprivate var filteredImage: UIImage?{
        willSet{
            self.filteredImageView.image = newValue
        }
    }
    fileprivate var editedImage : UIImage?
    fileprivate var originalImage : UIImage?{
        willSet{
            self.filteredImage = newValue
            self.originalImageView.image = newValue
        }
    }
    fileprivate let filters : [FilterType] = [.GrayScale, .Negative, .Brightness, .Reddish, .Greenish, .Blueish, .Contrast]
    fileprivate let kCellSpacing : CGFloat = 10
    fileprivate var selectedFilter : FilterType?

    //MARK: View Lifecycle Methods
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.filterMenu.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        self.filterMenu.translatesAutoresizingMaskIntoConstraints = false
        self.instensitySliderView.translatesAutoresizingMaskIntoConstraints = false

        self.originalImage = #imageLiteral(resourceName: "scenery")
        self.compareButton.isEnabled = false
        self.toggleButton.isEnabled = false
        self.editButton.isEnabled = false
    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    //MARK: Private Methods
    private func showCamera()
    {
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .camera
        
        present(cameraPicker, animated: true, completion: nil)
    }
    
    private func showAlbum()
    {
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .photoLibrary
        
        present(cameraPicker, animated: true, completion: nil)
    }
    
    private func showFilterMenu()
    {
        view.addSubview(filterMenu)
        
        let bottomConstraint = filterMenu.bottomAnchor.constraint(equalTo: bottomMenu.topAnchor)
        let leftConstraint = filterMenu.leftAnchor.constraint(equalTo: view.leftAnchor)
        let rightConstraint = filterMenu.rightAnchor.constraint(equalTo: view.rightAnchor)
        
        let heightConstraint = filterMenu.heightAnchor.constraint(equalToConstant: 118)
        
        NSLayoutConstraint.activate([bottomConstraint, leftConstraint, rightConstraint, heightConstraint])
        
        view.layoutIfNeeded()
        
        self.filterMenu.alpha = 0
        UIView.animate(withDuration: 0.4, animations: {
            self.filterMenu.alpha = 1.0
        })
    }
    
    private func hideFilterMenu()
    {
        UIView.animate(withDuration: 0.4, animations: {
            self.filterMenu.alpha = 0
            }, completion: { completed in
                if completed == true
                {
                    self.filterMenu.removeFromSuperview()
                }
        })
    }
    
    private func showIntensitySliderView()
    {
        view.addSubview(self.instensitySliderView)
        
        let bottomConstraint = self.instensitySliderView.bottomAnchor.constraint(equalTo: bottomMenu.topAnchor)
        let leftConstraint = self.instensitySliderView.leftAnchor.constraint(equalTo: view.leftAnchor)
        let rightConstraint = self.instensitySliderView.rightAnchor.constraint(equalTo: view.rightAnchor)
        
        let heightConstraint = self.instensitySliderView.heightAnchor.constraint(equalToConstant: 50)
        
        NSLayoutConstraint.activate([bottomConstraint, leftConstraint, rightConstraint, heightConstraint])
        
        view.layoutIfNeeded()
        
        self.instensitySliderView.alpha = 0
        UIView.animate(withDuration: 0.4, animations: {
            self.instensitySliderView.alpha = 1.0
        })
        self.minimumSliderValueLabel.text = String(describing: Int(self.selectedFilter!.range().minValue))
        self.maximumSliderValueLabel.text = String(describing: Int(self.selectedFilter!.range().maxValue))
        self.intensitySlider.minimumValue = Float(self.selectedFilter!.range().minValue)
        self.intensitySlider.maximumValue = Float(self.selectedFilter!.range().maxValue)
        self.intensitySlider.value = Float(self.selectedFilter!.range().currentValue)
    }
    
    private func hideIntensitySliderView()
    {
        self.filteredImage = self.editedImage
        self.editedImage = nil
        UIView.animate(withDuration: 0.4, animations: {
            self.instensitySliderView.alpha = 0
            }, completion: { completed in
                if completed == true
                {
                    self.instensitySliderView.removeFromSuperview()
                }
        })
    }
    
    //MARK: Button Action Methods
    @IBAction func onShare(_ sender: AnyObject)
    {
        if self.editButton.isSelected
        {
            self.editButton.isSelected = false
            self.hideIntensitySliderView()
        }
        if self.filterButton.isSelected
        {
            self.filterButton.isSelected = false
            self.hideFilterMenu()
        }
        let activityController = UIActivityViewController(activityItems: [self.filteredImage!], applicationActivities: nil)
        present(activityController, animated: true, completion: nil)
    }
    
    @IBAction func onNewPhoto(_ sender: AnyObject)
    {
        if self.editButton.isSelected
        {
            self.editButton.isSelected = false
            self.hideIntensitySliderView()
        }
        if self.filterButton.isSelected
        {
            self.filterButton.isSelected = false
            self.hideFilterMenu()
        }
        let actionSheet = UIAlertController(title: "New Photo", message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { action in
            self.showCamera()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Album", style: .default, handler: { action in
            self.showAlbum()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    @IBAction func onFilter(_ sender: UIButton)
    {
        if sender.isSelected
        {
            self.hideFilterMenu()
            sender.isSelected = false
        }
        else
        {
            if self.editButton.isSelected
            {
                self.editButton.isSelected = false
                self.hideIntensitySliderView()
            }
            self.showFilterMenu()
            sender.isSelected = true
        }
    }
    
    @IBAction func onCompare(_ sender: UIButton)
    {
        if sender.isSelected
        {
            UIView.animate(withDuration: 0.3, delay: 0.0, options: .transitionCrossDissolve, animations: {
                self.filteredImageView.alpha = 1.0

                }, completion: nil)
            sender.isSelected = false
        }
        else
        {
            UIView.animate(withDuration: 0.3, delay: 0.0, options: .transitionCrossDissolve, animations: {
                self.filteredImageView.alpha = 0.0
                
                }, completion: nil)
            sender.isSelected = true
        }
    }
    
    @IBAction func onEdit(_ sender: UIButton)
    {
        if sender.isSelected
        {
            self.hideIntensitySliderView()
            sender.isSelected = false
        }
        else
        {
            if self.filterButton.isSelected
            {
                self.filterButton.isSelected = false
                self.hideFilterMenu()
            }
            self.showIntensitySliderView()
            sender.isSelected = true
        }
    }
    
    @IBAction func adjustIntensity(_ sender: UISlider)
    {
        self.editedImage = self.filteredImage?.applyFilter(filterType: self.selectedFilter!, withParameter: Double(sender.value))
        self.filteredImageView.image = self.editedImage
    }
    
    @IBAction func showOriginalImage(_ sender: UIButton)
    {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .transitionCrossDissolve, animations: {
            self.filteredImageView.alpha = 0.0
            
            }, completion: nil)
    }
    
    
    @IBAction func showFilteredImage(_ sender: UIButton)
    {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .transitionCrossDissolve, animations: {
            self.filteredImageView.alpha = 1.0
            
            }, completion: nil)
    }
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate Methods
extension ViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    // MARK: UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        dismiss(animated: true, completion: nil)
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            let newImage = UIImage(cgImage: image.cgImage!, scale: 1.0, orientation: .up)
            self.originalImage = newImage
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate Methods
extension ViewController : UICollectionViewDataSource, UICollectionViewDelegate
{
    //UICollectionViewDataSource Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.filters.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "filterTypeCell", for: indexPath) as! FilterTypeCollectionViewCell
        if indexPath.row == 0
        {
            cell.filterTypeLabel.text = "None"
            cell.filterTypeImageView.image = #imageLiteral(resourceName: "scenery")
        }
        else
        {
            cell.filterTypeLabel.text = filters[indexPath.row - 1].rawValue
            cell.filterTypeImageView.image = UIImage(named: filters[indexPath.row - 1].rawValue)
        }
        return cell
    }
    
    //UICollectionViewDelegate Methods
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        self.compareButton.isSelected = false
        self.editButton.isSelected = false
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredVertically)
        if indexPath.row == 0
        {
            self.filteredImage = self.originalImage
            self.view.exchangeSubview(at: 2, withSubviewAt: 1)
            self.compareButton.isEnabled = false
            self.editButton.isEnabled = false
            self.toggleButton.isEnabled = false
            self.selectedFilter = nil
        }
        else
        {
            let filterType = self.filters[indexPath.row - 1]
            self.filteredImage = self.filteredImage?.applyDefaultFilter(filterType: filterType)
            self.view.exchangeSubview(at: 1, withSubviewAt: 2)
            self.compareButton.isEnabled = true
            self.editButton.isEnabled = true
            self.toggleButton.isEnabled = true
            self.selectedFilter = filterType
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout Methods
extension ViewController : UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: (collectionView.bounds.width - (2 * kCellSpacing))/3, height: collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    {
        return kCellSpacing
    }
}



