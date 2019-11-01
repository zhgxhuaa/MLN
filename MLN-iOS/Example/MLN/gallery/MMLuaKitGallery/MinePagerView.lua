---
--- Generated by MLN Team (http://www.immomo.com)
--- Created by MLN Team.
--- DateTime: 2019-09-05 12:05
---

local _class = {
    _name = 'MinePagerView',
    _version = '1.0'
}

---@public
function _class:new()
    local o = {}
    setmetatable(o, {__index = self})
    return o
end

---@public
function _class:rootView()
    if self.containerView then
        return self.containerView
    end
    self:createSubviews()
    return self.containerView
end

---@private
function _class:createSubviews()
    --容器视图
    self.containerView = View():width(MeasurementType.MATCH_PARENT):height(MeasurementType.MATCH_PARENT)

    --导航栏
    self.navigation = require("MMLuaKitGallery.NavigationBar"):new()
    self.navibar = self.navigation:bar("我的", nil)
    self.containerView:addView(self.navibar)

    --更多
    self.moreButton = ImageView()
    self.moreButton:marginLeft(20):width(22):height(22):setGravity(MBit:bor(Gravity.LEFT, Gravity.CENTER_VERTICAL))
    self.moreButton:contentMode(ContentMode.SCALE_ASPECT_FIT)
    self.moreButton:image("https://s.momocdn.com/w/u/others/2019/09/01/1567316383505-minmore.png")
    self.moreButton:onClick(function()
        Toast("更多内容敬请期待~", 1)
    end)
    self.navibar:addView(self.moreButton)

    --分享
    self.shareButton = ImageView()
    self.shareButton:marginRight(20):width(22):height(22):setGravity(MBit:bor(Gravity.RIGHT, Gravity.CENTER_VERTICAL))
    self.shareButton:contentMode(ContentMode.SCALE_ASPECT_FIT)
    self.shareButton:image("https://s.momocdn.com/w/u/others/2019/09/01/1567316383469-minshare.png")
    self.shareButton:onClick(function()
        Toast("快分享给微信好友吧~", 1)
    end)
    self.navibar:addView(self.shareButton)

    --布局除导航栏外所有子视图
    self.contentLayout = LinearLayout(LinearType.VERTICAL):width(MeasurementType.WRAP_CONTENT):height(MeasurementType.WRAP_CONTENT):marginTop(_NaviBarHeight)
    self.containerView:addView(self.contentLayout)

    --头部控件布局
    self.headerBaseView = View():width(MeasurementType.WRAP_CONTENT):height(MeasurementType.WRAP_CONTENT)
    self.contentLayout:addView(self.headerBaseView)

    --添加头部视图到headerBaseView上
    self:setupHeaderView()

    --tabSegment以及滚动视图布局
    self.segmentAndPagerBaseView = View():width(window:width()):height(MeasurementType.MATCH_PARENT)
    self.contentLayout:addView(self.segmentAndPagerBaseView)

    --添加tabSegment以及滚动视图到segmentAndPagerBaseView上
    self:setupSegmentView()
    self:setupViewPager()
end

---布局头部视图
---@private
function _class:setupHeaderView()
    self.headerLayout = LinearLayout(LinearType.VERTICAL):width(MeasurementType.WRAP_CONTENT):height(MeasurementType.WRAP_CONTENT)
    self.headerBaseView:addView(self.headerLayout)

    --头像和粉丝关注收藏等控件水平布局
    self.avatarLayout = LinearLayout(LinearType.HORIZONTAL):marginLeft(20):marginTop(20):width(MeasurementType.WRAP_CONTENT):height(MeasurementType.WRAP_CONTENT)
    self.headerLayout:addView(self.avatarLayout)

    --头像
    self.avatarView = ImageView():width(80):height(80)
    self.avatarView:contentMode(ContentMode.SCALE_ASPECT_FILL):cornerRadius(self.avatarView:height() / 2)
    self.avatarView:image("https://s.momocdn.com/w/u/others/2019/09/01/1567317657445-dilireba.jpeg")
    self.avatarView:onClick(function()
        Toast("快分享给微信好友吧~", 1)
    end)
    self.avatarLayout:addView(self.avatarView)

    --粉丝关注收藏控件和编辑资料按钮垂直布局
    self.editDataLayout = LinearLayout(LinearType.VERTICAL)
    self.editDataLayout:marginLeft(10):width(MeasurementType.WRAP_CONTENT):height(MeasurementType.WRAP_CONTENT)
    self.avatarLayout:addView(self.editDataLayout)

    self.itemLayout = LinearLayout(LinearType.HORIZONTAL):marginTop(5)
    self.editDataLayout:addView(self.itemLayout)

    self.itemLayouts = {}
    local itemText1s = {"80985", "2", "209292"}
    local itemText2s = {"粉丝", "关注", "赞和收藏"}
    for i, v in pairs(itemText1s) do
        local layout = self:setupItemLayout(v, itemText2s[i])
        self.itemLayout:addView(layout)
        table.insert(self.itemLayouts, layout) --避免layout被GC
    end

    --编辑资料
    local gapToScreen = 40
    local editLabelWidth = window:width() - self.avatarView:width() - 2 * gapToScreen
    self.editLabel = Label():marginTop(0):width(editLabelWidth):height(30)
    self.editLabel:text("编辑资料"):fontSize(15):textAlign(TextAlign.CENTER):textColor(_Color.LightBlack):cornerRadius(3)
    self.editLabel:bgColor(_Color.White):borderWidth(0.5):borderColor(Color(200,200,200))
    self.editLabel:onClick(function()
        Toast("编辑资料", 1)
    end)
    self.editDataLayout:addView(self.editLabel)

    --名字
    self.nameLabel = Label():marginLeft(20):marginTop(15):width(MeasurementType.WRAP_CONTENT):height(MeasurementType.WRAP_CONTENT)
    self.nameLabel:text("北京迪丽热巴"):fontSize(16):setTextFontStyle(FontStyle.BOLD)
    self.headerLayout:addView(self.nameLabel)

    --地区
    self.areaLabel = Label():marginLeft(20):marginTop(5):width(MeasurementType.WRAP_CONTENT):height(MeasurementType.WRAP_CONTENT)
    self.areaLabel:text("北京"):fontSize(13):textColor(_Color.LightBlack)
    self.headerLayout:addView(self.areaLabel)

    --分割线
    self.line = View()
    self.line:marginLeft(20):marginTop(20):marginRight(20):width(window:width()):height(0.5)
    self.line:bgColor(Color(210,210,210))
    self.headerLayout:addView(self.line)
end

---@private
function _class:setupItemLayout(text1, text2)
    local layout = LinearLayout(LinearType.VERTICAL)
    layout:marginLeft(0):width(80):height(50)

    local label1 = Label():width(MeasurementType.WRAP_CONTENT):setGravity(Gravity.CENTER)
    label1:text(text1):fontSize(15):setTextFontStyle(FontStyle.BOLD):textAlign(TextAlign.CENTER)
    layout:addView(label1)

    local label2 = Label():width(MeasurementType.WRAP_CONTENT):setGravity(Gravity.CENTER):marginTop(2)
    label2:text(text2):fontSize(11):textAlign(TextAlign.CENTER):textColor(Color(100,100,100))
    layout:addView(label2)

    --加到table里，避免被GC
    if self.itemLabels == nil then
        self.itemLabels = {}
    end
    table.insert(self.itemLabels, label1)
    table.insert(self.itemLabels, label2)

    return layout
end

---创建tagSegment视图
---@private
function _class:setupSegmentView()
    local titles = Array()
    titles:add("主页"):add("动态"):add("收藏")
    self.tabSegment = TabSegmentView(Rect(0, self.headerLayout:height() +  1, window:width(), 50), titles, _Color.Black)
    self.tabSegment:width(MeasurementType.MATCH_PARENT):setGravity(Gravity.CENTER_HORIZONTAL):selectScale(1.0)
    self.tabSegment:bgColor(_Color.White)
    self.tabSegment:setAlignment(TabSegmentAlignment.CENTER)
    self.segmentAndPagerBaseView:addView(self.tabSegment)
end

---创建滚动视图
---@private
function _class:setupViewPager()
    local top =0 + self.tabSegment:height()
    local cellIDs = {"homeCellId", "momentCellId", "collectCellId"}

    self.adapter = ViewPagerAdapter()
    self.adapter:getCount(function(_)
        return 3
    end)

    self.adapter:reuseId(function(pos)
        return cellIDs[pos]
    end)

    --主页
    self:setupHomeContentView()
    self.adapter:initCellByReuseId(cellIDs[1], function(cell, _)
        cell.contentView:addView(self.homeContentView)
    end)

    self.adapter:fillCellDataByReuseId(cellIDs[1], function(_, _)
        --must implement this method
    end)

    --动态
    self:setupMomentContentView()
    self.adapter:initCellByReuseId(cellIDs[2], function(cell, _)
        cell.contentView:addView(self.momentContentView)
    end)

    self.adapter:fillCellDataByReuseId(cellIDs[2], function(_, _)
        --must implement this method
    end)

    --收藏
    self:setupCollectContentView()
    self.adapter:initCellByReuseId(cellIDs[3], function(cell, _)
        cell.contentView:addView(self.collectCollectionView)
    end)

    self.adapter:fillCellDataByReuseId(cellIDs[3], function(_, _)
        --must implement this method
    end)

    self.viewPager = ViewPager():bgColor(_Color.White)
    self.viewPager:scrollToPage(1, false):showIndicator(false)
    self.viewPager:marginTop(top):width(window:width()):height(window:height() - top):setGravity(Gravity.CENTER_HORIZONTAL)
    self.viewPager:adapter(self.adapter)
    self.tabSegment:relatedToViewPager(self.viewPager, true)
    self.segmentAndPagerBaseView:addView(self.viewPager)
end

---主页
---@private
function _class:setupHomeContentView()
    self.homeContentView = View():width(MeasurementType.MATCH_PARENT):height(MeasurementType.MATCH_PARENT)
    self.homeContentView:bgColor(_Color.White)

    self.homeAvatarView = ImageView():marginLeft(0):width(140):height(160)
    self.homeAvatarView:contentMode(ContentMode.SCALE_ASPECT_FILL)
    self.homeAvatarView:image("https://s.momocdn.com/w/u/others/2019/09/01/1567317657445-dilireba.jpeg")
    self.homeContentView:addView(self.homeAvatarView)
end

---动态
---@private
function _class:setupMomentContentView()
    self.momentContentView = View():width(MeasurementType.MATCH_PARENT):height(MeasurementType.MATCH_PARENT)

    self.momentLabelLayout = LinearLayout(LinearType.HORIZONTAL)
    self.momentLabelLayout:marginLeft(30):marginTop(10):marginRight(30):width(MeasurementType.MATCH_PARENT):height(50)
    self.momentContentView:addView(self.momentLabelLayout)

    self.momentDateLabel = Label():width(MeasurementType.WRAP_CONTENT):setGravity(Gravity.CENTER)
    self.momentDateLabel:fontSize(22):setTextFontStyle(FontStyle.BOLD)
    self.momentDateLabel:text("2019.08.22")
    self.momentLabelLayout:addView(self.momentDateLabel)

    self.momentTimeLabel = Label():marginLeft(5):width(MeasurementType.WRAP_CONTENT):setGravity(Gravity.CENTER)
    self.momentTimeLabel:fontSize(19):textColor(_Color.Gray)
    self.momentTimeLabel:text("10:43")
    self.momentLabelLayout:addView(self.momentTimeLabel)

    self.momentImageView = ImageView()
    self.momentImageView:marginLeft(30):marginTop(self.momentLabelLayout:marginTop() + self.momentLabelLayout:height()):marginRight(30):width(MeasurementType.MATCH_PARENT):height(350)
    self.momentImageView:contentMode(ContentMode.SCALE_ASPECT_FILL)
    self.momentImageView:image("https://s.momocdn.com/w/u/others/2019/09/01/1567317657445-dilireba.jpeg")
    self.momentContentView:addView(self.momentImageView)
end

---收藏
---@private
function _class:setupCollectContentView()
    self.collectCollectionView = View():width(MeasurementType.MATCH_PARENT):height(MeasurementType.MATCH_PARENT)
    self.collectCollectionView:bgColor(_Color.White)

    self.collectLine = View():width(MeasurementType.MATCH_PARENT):height(10)
    self.collectLine:bgColor(_Color.LightGray)
    self.collectCollectionView:addView(self.collectLine)

    local labelTop = 30
    local labelHeight = 30
    self.collectTitleLabel = Label():marginLeft(20):marginTop(labelTop):width(MeasurementType.WRAP_CONTENT):height(labelHeight)
    self.collectTitleLabel:text("我的灵感集"):fontSize(16):setTextFontStyle(FontStyle.BOLD)
    self.collectCollectionView:addView(self.collectTitleLabel)

    local createLabelWidth = 70
    self.collectCreateLabel = Label():marginLeft(window:width() - createLabelWidth):marginTop(labelTop):width(createLabelWidth):height(labelHeight)
    self.collectCreateLabel:text("+新建"):fontSize(16)
    self.collectCreateLabel:bgColor(_Color.White)
    self.collectCreateLabel:onClick(function()
        Toast("新建灵感集", 1)
    end)
    self.collectCollectionView:addView(self.collectCreateLabel)

    local tableViewTop = labelTop + labelHeight + 20
    self.collectTableView = TableView(false, false)
    self.collectTableView:marginTop(tableViewTop):width(MeasurementType.MATCH_PARENT):height(MeasurementType.MATCH_PARENT)
    self.collectCollectionView:addView(self.collectTableView)

    local adapter = TableViewAutoFitAdapter()
    self.collectTableView:adapter(adapter)
    self.collectTableViewAdapter = adapter

    adapter:sectionCount(function()
        return 1
    end)

    adapter:rowCount(function(_)
        return 1
    end)

    adapter:initCell(function(cell)
        cell.contentView:addView(self:collectCell())
        cell.contentView:bgColor(_Color.White)
    end)

    adapter:fillCellData(function (_, _, _)
        --do nothing
    end)
end

---收藏页tableView cell
---@private
function _class:collectCell()
    self.cellBaseView = View():width(MeasurementType.MATCH_PARENT):height(MeasurementType.WRAP_CONTENT)
    self.cellBaseView:onClick(function()
        Toast("我的灵感集", 1)
    end)

    self.collectCellLayout = LinearLayout(LinearType.HORIZONTAL):marginLeft(20):width(MeasurementType.WRAP_CONTENT):height(MeasurementType.WRAP_CONTENT):setMaxWidth(window:width() - 40)
    self.cellBaseView:addView(self.collectCellLayout)

    self.cellAvatarView = ImageView():width(50):height(50):setGravity(MBit:bor(Gravity.LEFT, Gravity.CENTER_VERTICAL))
    self.cellAvatarView:image("https://s.momocdn.com/w/u/others/2019/09/01/1567317657445-dilireba.jpeg")
    self.cellAvatarView:contentMode(ContentMode.SCALE_ASPECT_FILL)
    self.collectCellLayout:addView(self.cellAvatarView)

    self.cellLabelLayout = LinearLayout(LinearType.VERTICAL):marginLeft(10):setGravity(Gravity.CENTER_VERTICAL)
    self.collectCellLayout:addView(self.cellLabelLayout)

    self.cellTitleLabel = Label():width(MeasurementType.WRAP_CONTENT):height(MeasurementType.WRAP_CONTENT)
    self.cellTitleLabel:text("美丽"):setTextFontStyle(FontStyle.BOLD):fontSize(14)
    self.cellLabelLayout:addView(self.cellTitleLabel)

    self.cellDescLabel = Label():width(MeasurementType.WRAP_CONTENT):height(MeasurementType.WRAP_CONTENT):marginTop(5)
    self.cellDescLabel:text("1篇内容 | 1人浏览"):textColor(_Color.MediumGray):fontSize(12)
    self.cellLabelLayout:addView(self.cellDescLabel)

    self.cellArrowView = ImageView():width(20):height(20):setGravity(MBit:bor(Gravity.RIGHT, Gravity.CENTER_VERTICAL)):marginRight(20)
    self.cellArrowView:image("https://s.momocdn.com/w/u/others/2019/08/31/1567264720561-rightarrow.png")
    self.cellBaseView:addView(self.cellArrowView)

    return self.cellBaseView
end

return _class