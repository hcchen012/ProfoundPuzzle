//
//  ViewController.swift
//  ProfoundPuzzle
//
//  Created by Hannah Chen on 10/15/22.
//


import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let questionImageArray = [#imageLiteral(resourceName: "layer1"), #imageLiteral(resourceName: "layer2"), #imageLiteral(resourceName: "layer3"), #imageLiteral(resourceName: "layer4"), #imageLiteral(resourceName: "layer5"), #imageLiteral(resourceName: "layer6"), #imageLiteral(resourceName: "layer7"), #imageLiteral(resourceName: "layer8"), #imageLiteral(resourceName: "layer9")]
    let correctAns = [0,1,2,3,4,5,6,7,8]
    var wrongAns = Array(0..<9)
    var wrongImageArray=[UIImage]()
    var undoMovesArray = [(first: IndexPath, second: IndexPath)]()
    var numberOfMoves = 0
    
    var firstIndexPath: IndexPath?
    var secondIndexPath: IndexPath?
    
    
    
    @IBOutlet weak var numMoves: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Puzzle"
        self.navigationController?.navigationBar.isTranslucent = false
        
        wrongImageArray = questionImageArray
        setupViews()
        let temp0 = wrongImageArray[2]
        let temp1 = wrongImageArray[1]
        let temp2 = wrongImageArray[0]
        let temp3 = wrongImageArray[6]
        let temp4 = wrongImageArray[5]
        let temp5 = wrongImageArray[7]
        let temp6 = wrongImageArray[8]
        let temp7 = wrongImageArray[4]
        let temp8 = wrongImageArray[3]
        wrongImageArray[0] = temp0
        wrongImageArray[1] = temp1
        wrongImageArray[2] = temp2
        wrongImageArray[3] = temp3
        wrongImageArray[4] = temp4
        wrongImageArray[5] = temp5
        wrongImageArray[6] = temp6
        wrongImageArray[7] = temp7
        wrongImageArray[8] = temp8
        wrongAns[0] = 2
        wrongAns[1] = 1
        wrongAns[2] = 0
        wrongAns[3] = 6
        wrongAns[4] = 5
        wrongAns[5] = 7
        wrongAns[6] = 8
        wrongAns[7] = 4
        wrongAns[8] = 3
        
        
    }
    
    
    @IBAction func swapAction(_ sender: Any) {
        guard let start = firstIndexPath, let end = secondIndexPath else { return }
        myCollectionView.performBatchUpdates({
            myCollectionView.moveItem(at: start, to: end)
            myCollectionView.moveItem(at: end, to: start)
        }) { (finished) in
            // update data source here
//            print(wrongAns)
            self.myCollectionView.deselectItem(at: start, animated: true)
            self.myCollectionView.deselectItem(at: end, animated: true)
            self.firstIndexPath = nil
            self.secondIndexPath = nil
            self.wrongImageArray.swapAt(start.item, end.item)
            self.wrongAns.swapAt(start.item, end.item)
            self.undoMovesArray.append((first: start, second: end))
            self.numberOfMoves += 1
            self.numMoves.text = "Number of Moves: \(self.numberOfMoves)"
            print(self.wrongAns)
            if self.wrongAns == self.correctAns {
                let alert=UIAlertController(title: "You Won!", message: "Congratulations 👍", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                let restartAction = UIAlertAction(title: "Restart", style: .default, handler: { (action) in
                    self.restartGame()
                })
                alert.addAction(okAction)
                alert.addAction(restartAction)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func undoAction(_ sender: Any) {
        if undoMovesArray.count == 0 {
            return
        }
        let start = undoMovesArray.last!.first
        let end = undoMovesArray.last!.second
        myCollectionView.performBatchUpdates({
            myCollectionView.moveItem(at: start, to: end)
            myCollectionView.moveItem(at: end, to: start)
        }) { (finished) in
            // update data source here
            self.wrongImageArray.swapAt(start.item, end.item)
            self.wrongAns.swapAt(start.item, end.item)
            self.undoMovesArray.removeLast()
            self.numberOfMoves += 1
            self.numMoves.text = "Number of Moves: \(self.numberOfMoves)"
        }
    }
    

    
    func restartGame() {
        self.undoMovesArray.removeAll()
        wrongAns = Array(0..<9)
        wrongImageArray = questionImageArray
        firstIndexPath = nil
        secondIndexPath = nil
        self.numberOfMoves = 0
        self.numMoves.text = "Number of Moves: \(numberOfMoves)"
        self.myCollectionView.reloadData()
    }
    
    
    // CollectionView
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ImageViewCVCell
        cell.imgView.image=wrongImageArray[indexPath.item]
        return cell
    }
        
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if firstIndexPath == nil {
            firstIndexPath = indexPath
            collectionView.selectItem(at: firstIndexPath, animated: true, scrollPosition: UICollectionView.ScrollPosition(rawValue: 0))
        } else if secondIndexPath == nil {
            secondIndexPath = indexPath
            collectionView.selectItem(at: secondIndexPath, animated: true, scrollPosition: UICollectionView.ScrollPosition(rawValue: 0))
        } else {
            collectionView.deselectItem(at: secondIndexPath!, animated: true)
            secondIndexPath = indexPath
            collectionView.selectItem(at: secondIndexPath, animated: true, scrollPosition: UICollectionView.ScrollPosition(rawValue: 0))
        }
    }
        
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if indexPath == firstIndexPath {
            firstIndexPath = nil
        } else if indexPath == secondIndexPath {
            secondIndexPath = nil
        }
    }
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        return CGSize(width: width/3, height: width/3)
    }
        
    func setupViews() {
        myCollectionView.delegate=self
        myCollectionView.dataSource=self
        myCollectionView.register(ImageViewCVCell.self, forCellWithReuseIdentifier: "Cell")
        myCollectionView.backgroundColor=UIColor.white

        self.view.addSubview(myCollectionView)
        myCollectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive=true
        myCollectionView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 20).isActive=true
        myCollectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -21).isActive=true
        myCollectionView.heightAnchor.constraint(equalTo: myCollectionView.widthAnchor).isActive=true
            
//            self.view.addSubview(btnSwap)
//            btnSwap.widthAnchor.constraint(equalToConstant: 200).isActive=true
//            btnSwap.topAnchor.constraint(equalTo: myCollectionView.bottomAnchor, constant: 20).isActive=true
//            btnSwap.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive=true
//            btnSwap.heightAnchor.constraint(equalToConstant: 50).isActive=true
//            btnSwap.addTarget(self, action: #selector(btnSwapAction), for: .touchUpInside)
            
//            self.view.addSubview(btnUndo)
//            btnUndo.widthAnchor.constraint(equalToConstant: 200).isActive=true
//            btnUndo.topAnchor.constraint(equalTo: btnSwap.bottomAnchor, constant: 30).isActive=true
//            btnUndo.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive=true
//            btnUndo.heightAnchor.constraint(equalToConstant: 50).isActive=true
//            btnUndo.addTarget(self, action: #selector(btnUndoAction), for: .touchUpInside)
            
//            self.view.addSubview(lblMoves)
//            lblMoves.widthAnchor.constraint(equalToConstant: 200).isActive=true
//            lblMoves.topAnchor.constraint(equalTo: btnUndo.bottomAnchor, constant: 20).isActive=true
//            lblMoves.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive=true
//            lblMoves.heightAnchor.constraint(equalToConstant: 50).isActive=true
//            lblMoves.text = "Moves: \(numberOfMoves)"
    }
        
    let myCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing=0
        layout.minimumLineSpacing=0
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        cv.allowsMultipleSelection = true
        cv.translatesAutoresizingMaskIntoConstraints=false
        return cv
    }()
        
//        let btnSwap: UIButton = {
//            let btn=UIButton(type: .system)
//            btn.setTitle("Swap", for: .normal)
//            btn.titleLabel?.font = UIFont.systemFont(ofSize: 20)
//            btn.translatesAutoresizingMaskIntoConstraints=false
//            return btn
//        }()
        
//    let btnUndo: UIButton = {
//        let btn=UIButton(type: .system)
//        btn.setTitle("Undo", for: .normal)
//        btn.setTitleColor(UIColor.red, for: .normal)
//        btn.translatesAutoresizingMaskIntoConstraints=false
//        return btn
//    }()
//
//    let lblMoves: UILabel = {
//        let lbl=UILabel()
//        lbl.textAlignment = .center
//        lbl.translatesAutoresizingMaskIntoConstraints=false
//        return lbl
//    }()
    
    
}



