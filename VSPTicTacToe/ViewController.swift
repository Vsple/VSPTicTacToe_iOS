//
//  ViewController.swift
//  VSPTicTacToe
//
//  Created by Vivek Patel on 27/03/22.
//

import UIKit

final class ViewController: UIViewController {
    
    // MARK: - Variables
    private var playersGround: [Playerground] = []
    private var player: Player = .cross {
        didSet {
            lblTurn.text = player.playerTurnText
        }
    }
    private var crossTotalWins = 0 {
        didSet {
            lblPlayerXScore.text = crossTotalWins.description
        }
    }
    private var circleTotalWins = 0 {
        didSet {
            lblPlayerOScore.text = circleTotalWins.description
        }
    }
    private var totalTies = 0 {
        didSet {
            lblTiesScore.text = totalTies.description
        }
    }
    
    // MARK: - Outlets
    @IBOutlet weak var mainView: UIStackView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var lblPlayerXScore: UILabel!
    @IBOutlet weak var lblTiesScore: UILabel!
    @IBOutlet weak var lblPlayerOScore: UILabel!
    
    // MARK: - Turn
    var turnView: UIStackView!
    var lblTurn: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - View life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addTurnView()
        addData()
    }
    
}
// MARK: - Convenience
extension ViewController {
    
    private func addTurnView() {
        let lblPlaceholder = getPlaceholderLable(withText: "Turn")
        turnView = UIStackView(arrangedSubviews: [lblPlaceholder, lblTurn])
        turnView.axis = .vertical
        turnView.alignment = .center
        turnView.spacing = 0.0
        mainView.insertArrangedSubview(turnView, at: 0)
    }
    private func addData() {
        for i in 0..<9 {
            playersGround.append(Playerground(index: i))
        }
        lblTurn.text = player.playerTurnText
        collectionView.reloadData()
    }
    
    private func checkForVictory() {
        
        let crossIndexes = playersGround.filter({$0.playerType == .cross}).map({$0.index})
        let circleIndexes = playersGround.filter({$0.playerType == .circle}).map({$0.index})
        
        let winningCombinations = [[0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]]
        
        let crossWins = winningCombinations.first { values in
            let set = Set(crossIndexes)
            return values.allSatisfy(set.contains(_:))
        }
        
        guard crossWins == nil else {
            playerWon(.cross)
            return
        }
        
        let circleWins = winningCombinations.first { values in
            let set = Set(circleIndexes)
            return values.allSatisfy(set.contains(_:))
        }
        
        guard circleWins == nil else {
            playerWon(.circle)
            return
        }
        
        guard (crossIndexes.count + circleIndexes.count) == 9 else {
            return
        }
        playerWon(.none)
    }
    
    private func playerWon(_ player: Player) {
        switch player {
        case .cross:
            crossTotalWins += 1
        case .circle:
            circleTotalWins += 1
        case .none:
            totalTies += 1
        }
        showAlertOnResult(player.messageOnResult)
    }

    private func resetData() {
        playersGround.removeAll()
        addData()
    }
}
// MARK: - Resuable
extension ViewController {
    
    private func getPlaceholderLable(withText text: String) -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.text =  text
        label.textAlignment = .center
        return label
    }
    
    private func showAlertOnResult(_ message: String) {
        let alert = UIAlertController(title: "Result", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { action in
            self.resetData()
        }))
        self.present(alert, animated: true)
    }
}
// MARK: - Collection view data source
extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return playersGround.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: PlayCollectionViewCell.self), for: indexPath) as! PlayCollectionViewCell
        let player = playersGround[indexPath.row]
        cell.lblText.text = player.playerType.tappedText
        return cell
    }
}

// MARK: - Collection view delegate flow layout
extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 21)/3
        return CGSize(width: width, height: width)
    }
}

// MARK: - Collection view delegate
extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var playerGround = playersGround[indexPath.row]
        guard playerGround.playerType == .none else { return }
        
        switch player {
        case .cross:
            playerGround.playerType = .cross
            player = .circle
        case .circle:
            playerGround.playerType = .circle
            player = .cross
        case .none:
            break
        }
        playersGround[indexPath.row] = playerGround
        collectionView.reloadItems(at: [indexPath])
        checkForVictory()
    }
}
