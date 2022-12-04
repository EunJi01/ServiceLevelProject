//
//  StudySearchViewController.swift
//  ServiceLevelProject
//
//  Created by 황은지 on 2022/11/18.
//

import UIKit
import RxSwift
import RxCocoa

final class StudySearchViewController: UIViewController, CustomView {
    let disposeBag = DisposeBag()
    let vm = StudySearchViewModel()

    private let collectionView: UICollectionView = {
        let layout = StudyListLayout()
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.register(StudySearchCollectionViewCell.self, forCellWithReuseIdentifier: StudySearchCollectionViewCell.reuseIdentifier)
        if let flowLayout = view.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
          }
        view.register(StudySearchCollectionViewHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: StudySearchCollectionViewHeader.reuseIdentifier)
        return view
    }()
    
    private let searchBar: UISearchBar = {
        var width = UIScreen.main.bounds.size.width
        let view = UISearchBar(frame: CGRect(x: 0, y: 0, width: width - 10, height: 0))
        view.placeholder = "띄어쓰기로 복수 입력이 가능해요"
        view.searchTextField.font = .systemFont(ofSize: 14)
        return view
    }()
    
    private lazy var searchSesacButton: UIButton = customButton(title: "새싹 찾기", backgroundColor: .green)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        collectionView.delegate = self
        collectionView.dataSource = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: searchBar)
        
        bind()
        setConfigure()
        setConstraints()
    }
    
    private func bind() {
        let input = StudySearchViewModel.Input(
            returnKey: searchBar.rx.searchButtonClicked
                .withLatestFrom(searchBar.rx.text.orEmpty)
                .asSignal(onErrorJustReturn: ""),
            searchSesacButton: searchSesacButton.rx.tap.asSignal(onErrorJustReturn: ())
        )
        
        let output = vm.transform(input: input)
        
        output.addStudy
            .withUnretained(self)
            .emit { vc, textList in
                vc.searchBar.text = ""
                vc.collectionView.reloadData()
            }
            .disposed(by: disposeBag)
        
        output.showToast
            .withUnretained(self)
            .emit { vc, text in
                vc.view.makeToast(text, position: .top)
            }
            .disposed(by: disposeBag)
        
        output.pushNextVC
            .withUnretained(self)
            .emit { vc, _ in
                let nextVC = SearchTabViewController()
                nextVC.center = vc.vm.center
                vc.transition(nextVC, transitionStyle: .push)
            }
            .disposed(by: disposeBag)
        
        output.endEditting
            .withUnretained(self)
            .emit { vc, _ in
                vc.searchBar.endEditing(true)
            }
            .disposed(by: disposeBag)
    }
    
    private func setConfigure() {
        [collectionView, searchSesacButton].forEach {
            view.addSubview($0)
        }
    }
    
    private func setConstraints() {
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(32)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(80)
        }
        
        searchSesacButton.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(48)
        }
    }
}

extension StudySearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if indexPath.row < vm.recommendedStudy.count {
                vm.validate(text: vm.recommendedStudy[indexPath.row])
            } else {
                vm.validate(text: vm.nearbyStudy[indexPath.row - vm.recommendedStudy.count])
            }
        } else if indexPath.section == 1 {
            vm.wishStudy.remove(at: indexPath.row)
        }
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return vm.recommendedStudy.count + vm.nearbyStudy.count
        } else {
            return vm.wishStudy.count
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StudySearchCollectionViewCell.reuseIdentifier, for: indexPath) as? StudySearchCollectionViewCell else { return UICollectionViewCell() }
        
        if indexPath.section == 0 {
            if indexPath.row < vm.recommendedStudy.count {
                cell.studyLabel.textColor = .setColor(.error)
                cell.borderView.layer.borderColor = UIColor.setColor(.error).cgColor
                cell.studyLabel.text = vm.recommendedStudy[indexPath.row]
            } else {
                cell.studyLabel.textColor = .black
                cell.borderView.layer.borderColor = UIColor.setColor(.gray3).cgColor
                cell.studyLabel.text = vm.nearbyStudy[indexPath.row - vm.recommendedStudy.count]
            }
            
        } else {
            cell.studyLabel.textColor = .setColor(.green)
            cell.borderView.layer.borderColor = UIColor.setColor(.green).cgColor
            cell.studyLabel.text = "\(vm.wishStudy[indexPath.row])  X"
        }
        
        return cell
    }
}

extension StudySearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader, let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: StudySearchCollectionViewHeader.reuseIdentifier, for: indexPath) as? StudySearchCollectionViewHeader else { return UICollectionReusableView() }
        
        if indexPath.section == 0 {
            header.studyLabel.text = "지금 추천하는"
        } else {
            header.studyLabel.text = "내가 하고 싶은"
        }
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.size.width, height: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
    }
}
