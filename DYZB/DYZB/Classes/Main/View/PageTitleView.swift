//
//  PageTitleView.swift
//  DYZB
//
//  Created by YueAndy on 2017/10/20.
//  Copyright © 2017年 YueAndy. All rights reserved.
//

import UIKit

//MARK:定义代理协议
protocol PageTitleViewDelegate : class {
    func pageTitleView(pageTitleView : PageTitleView,selectedIndex : Int)
}

//MARK:定义常量
let kScrollLineH :CGFloat = 2
let kNormalColor : (CGFloat,CGFloat,CGFloat) = (85,85,85)
let kSelectColor : (CGFloat,CGFloat,CGFloat) = (255,128,0)

//定义类
class PageTitleView: UIView {
    
    weak var delegate :PageTitleViewDelegate?
    
    private var currentIndex : Int = 0
    
    private let titles:[String]
    
    private lazy var titleLabels:[UILabel] = [UILabel]()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false //是否显⽰示⽔水平滚动条
        scrollView.scrollsToTop = false
        scrollView.bounces = false //设置UIScrollView是否需要弹簧效果
        return scrollView;
    }()
    
    private lazy var scrollLine: UIView = {
        let scrollLine = UIView();
        scrollLine.backgroundColor = UIColor.orange
        return scrollLine
    }()
    
    
    
    init(frame: CGRect,titles: [String]) {
        self.titles = titles

        super.init(frame:frame)
        
        //Mark: 设置UI
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PageTitleView{
    
    private func setupUI(){
        //MARK:添加scrollview
        addSubview(scrollView)
        scrollView.frame = bounds
        //MARK:初始化labels
        setupLabels()
        //        MARK:添加底部线和底部滑块
        setupBottomLineAndScrollLine()
    }
    
    private func setupLabels() {
        let labelW :CGFloat = frame.width/CGFloat(titles.count)
        let labelY :CGFloat = 0
        let labelH :CGFloat = frame.height - kScrollLineH
        
        for (index,title) in titles.enumerated(){
            let label = UILabel()
            label.tag = index
            label.text = title
            label.textAlignment = .center
            label.textColor = UIColor(r: kNormalColor.0, g: kNormalColor.1, b: kNormalColor.2)
            if label.tag == 0 {
                label.textColor = UIColor(r: kSelectColor.0, g: kSelectColor.1, b: kSelectColor.2)
            }
            
            let labelX :CGFloat = labelW * CGFloat(index)
            label.frame = CGRect(x: labelX, y: labelY, width: labelW, height: labelH)
            
            scrollView.addSubview(label)
            titleLabels.append(label)
            //MARK:给label添加点击手势
            label.isUserInteractionEnabled = true
            let tapGest = UITapGestureRecognizer(target: self, action: #selector(labelClick(tap:)))
            label.addGestureRecognizer(tapGest)
        }
    }
    
    private func setupBottomLineAndScrollLine() {
        //        MARK:添加底部线
        let bottomLine = UIView()
        bottomLine.frame = CGRect(x: 0, y: frame.height - 0.5, width: kScreenW, height: 0.5)
        bottomLine.backgroundColor = UIColor.darkGray
        addSubview(bottomLine)
        //        MARK:添加底部滑动线
//        获取第一个label
        guard let firstLabel = titleLabels.first else {return}
        
        scrollView.addSubview(scrollLine)
        scrollLine.frame = CGRect(x: firstLabel.frame.origin.x, y: frame.height-kScrollLineH, width: firstLabel.frame.width, height: kScrollLineH)
    }
    
    
}

//MARK:label点击扩展
extension PageTitleView{
    @objc private func labelClick(tap:UITapGestureRecognizer){
        guard let currentLabel = tap.view as? UILabel else {return}
        currentLabel.textColor = UIColor(r: kSelectColor.0, g: kSelectColor.1, b: kSelectColor.2)
        
        titleLabels[currentIndex].textColor = UIColor(r: kNormalColor.0, g: kNormalColor.1, b: kNormalColor.2)
        
        currentIndex = currentLabel.tag
        
        let scrollLineX = CGFloat(currentIndex) * scrollLine.frame.width
        UIView.animate(withDuration: 0.15) {[weak self] in
            self?.scrollLine.frame.origin.x = scrollLineX
        }
        //MARK:通知调用代理方法
        delegate?.pageTitleView(pageTitleView: self, selectedIndex: currentIndex)
    }
}

//MARK:对外暴露方法
extension PageTitleView {
    func setTitle(progress : CGFloat , sourceIndex : Int ,targetIndex : Int)  {
        //1.取出sourceLabel和targetLabel
        let sourceLabel = titleLabels[sourceIndex]
        let targetLabel = titleLabels[targetIndex]
        
        //2.scrollLine 滑动逻辑
        let totalX = targetLabel.frame.origin.x - sourceLabel.frame.origin.x
        let moveX  = totalX * progress
        scrollLine.frame.origin.x = sourceLabel.frame.origin.x + moveX
        
        //3.label的颜色渐变
        //3.1颜色变化的范围
        let colorScope = (kSelectColor.0 - kNormalColor.0, kSelectColor.1 - kNormalColor.1, kSelectColor.2 - kNormalColor.2)
        //3.2sourceLabel的颜色改变
        sourceLabel.textColor = UIColor(r: kSelectColor.0 - colorScope.0 * progress, g: kSelectColor.1 - colorScope.1 * progress, b: kSelectColor.2 - colorScope.2 * progress)
        //3.3.targetLable的颜色改变
        targetLabel.textColor = UIColor(r: kNormalColor.0 + colorScope.0 * progress, g: kNormalColor.1 + colorScope.1 * progress, b: kNormalColor.2 + colorScope.2 * progress)
        
        //保存当前的index
        currentIndex = targetIndex
    }
}









