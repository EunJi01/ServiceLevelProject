//
//  StudySearchViewController.swift
//  ServiceLevelProject
//
//  Created by 황은지 on 2022/11/18.
//

import UIKit
import RxSwift
import RxCocoa

class StudySearchViewController: UIViewController, CustomView {
    let disposeBag = DisposeBag()
    let vm = StudySearchViewModel()

    private let collectionView: UICollectionView = {
        let layout = CollectionViewLeftAlignFlowLayout()
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
    
    private lazy var searchSesacButton: UIButton = customButton(title: "새싹 찾기")
    
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
                vc.collectionView.reloadData()
            }
            .disposed(by: disposeBag)
        
        output.showToast
            .withUnretained(self)
            .emit { vc, text in
                vc.view.makeToast(text, position: .top)
            }
            .disposed(by: disposeBag)
    }
    
    private func setConfigure() {
        searchSesacButton.backgroundColor = .setColor(.green)
        
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
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        print("11")
        // MARK: 메서드 자체가 실행이 안된다!
        guard kind == UICollectionView.elementKindSectionHeader, let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: StudySearchCollectionViewHeader.reuseIdentifier, for: indexPath) as? StudySearchCollectionViewHeader else { return UICollectionReusableView() }
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        print("22")
        // MARK: 메서드 자체가 실행이 안된다!
        return CGSize(width: UIScreen.main.bounds.size.width, height: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return vm.recommendedStudy.value.count + vm.nearbyStudy.value.count
        } else {
            return vm.wishStudy.value.count
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StudySearchCollectionViewCell.reuseIdentifier, for: indexPath) as? StudySearchCollectionViewCell else { return UICollectionViewCell() }
        
        if indexPath.section == 0 {
            if indexPath.row < vm.recommendedStudy.value.count {
                cell.studyLabel.text = vm.recommendedStudy.value[indexPath.row]
            } else {
                cell.studyLabel.text = vm.nearbyStudy.value[indexPath.row - vm.recommendedStudy.value.count]
            }
            
        } else {
            cell.studyLabel.text = vm.wishStudy.value[indexPath.row]
        }
        
        return cell
    }
}
