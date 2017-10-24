//
//  PageContenView.swift
//  DYZB
//
//  Created by YueAndy on 2017/10/21.
//  Copyright © 2017年 YueAndy. All rights reserved.
//

import UIKit

protocol PageContenViewDelegate {
    func pageContenView(pageContenView : PageContenView,progress : CGFloat ,sourceIndex : Int ,targetIndex : Int)
}

let kCollectionCellID = "kCollectionCellID"

class PageContenView: UIView {
    private var childVcs:[UIViewController]
    private weak var parentenVc:UIViewController?
    private var startOffsetX : CGFloat = 0
    //是否禁止滑动
    private var isForbidScroll = false
    
    var delegate : PageContenViewDelegate?
    
    //MARK:-懒加载属性
    private lazy var collectionView : UICollectionView = { [weak self] in
        //1.创建layout
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = (self?.bounds.size)!
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        //2.创建UICollectionView
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.bounces = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: kCollectionCellID)
        return collectionView
    }()
    
    init(frame: CGRect,childVcs:[UIViewController],parentenVc:UIViewController?) {
        self.childVcs = childVcs
        self.parentenVc = parentenVc
        super.init(frame: frame)
        
        //设置UI
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension PageContenView {
    private func setupUI(){
        //1.将所有的子控制器添加到副控制器中
        for childVc in childVcs {
            parentenVc?.addChildViewController(childVc)
        }
        
        //2.UICollectionView用于存在
        addSubview(collectionView)
        collectionView.frame = bounds
    }
}

//MARK:collectionView DataSource
extension PageContenView :UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return childVcs.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //1.创建cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCollectionCellID, for:indexPath)
        //2. 设置cell的内容
        let childVc = childVcs[indexPath.item]
        childVc.view.frame = cell.contentView.bounds
        cell.contentView.addSubview(childVc.view)
        return cell
    }
    
}

//MARK:collectionView delegate
extension PageContenView : UICollectionViewDelegate {
    
    //开始滑动
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isForbidScroll = false
        startOffsetX = scrollView.contentOffset.x
    }
    
    //滑动停止
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if isForbidScroll {return}
        
        //MARK:定义划定进度，滑动开始位置，滑动目标位置
        var progress : CGFloat = 0
        var sourceIndex : Int = 0
        var targetIndex : Int = 0
        
        let currentOffsetX = scrollView.contentOffset.x
        let collectionViewW = collectionView.frame.width
        
        if(currentOffsetX > startOffsetX){//左滑
            progress = currentOffsetX / collectionViewW - floor(currentOffsetX / collectionViewW)
            sourceIndex = Int(currentOffsetX / collectionViewW)
            
            targetIndex = sourceIndex + 1
            
            if (targetIndex >= childVcs.count){
                targetIndex = childVcs.count - 1
            }
            
            if currentOffsetX - startOffsetX == collectionViewW {
                progress = 1
                targetIndex = sourceIndex
            }
            
        }else { // 右滑
            progress = 1 - (currentOffsetX / collectionViewW - floor(currentOffsetX / collectionViewW))
            
            targetIndex = Int(currentOffsetX / collectionViewW)
            
            sourceIndex = targetIndex + 1
            
            if (sourceIndex >= childVcs.count){
                sourceIndex = childVcs.count - 1
            }
        }
        
        //MARK: 通知调用代理方法
        delegate?.pageContenView(pageContenView: self, progress: progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
}

//MARK:对外暴露的方法，点击会调用这个
extension PageContenView {
    func setCurrentIndex(currentIndex : Int)  {
        isForbidScroll = true
        let offX = CGFloat(currentIndex) * collectionView.frame.width
        collectionView.setContentOffset(CGPoint(x:offX,y:0), animated: false)
    }
}

