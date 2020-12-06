
function ISInventoryPane:dumpAll(player)
  
  local playerObj = getSpecificPlayer(self.player)
  local hotBar = getPlayerHotbar(self.player)
  local it = getPlayerLoot(self.player).inventory:getItems();

  for i = 0, it:size()-1 do
    local item = it:get(i);
    if not item:isEquipped()
      and item:getType() ~= "KeyRing"
      and not hotBar:isInHotbar(item)
      and not item:isFavorite()
      and (not instanceof(item, "Moveable") or item:getSpriteGrid() ~= nil or item:CanBeDroppedOnFloor())
    then
      ISInventoryPaneContextMenu.dropItem(item, self.player)
    end
  end

  self.selected = {};
  getPlayerLoot(self.player).inventoryPane.selected = {};
  getPlayerInventory(self.player).inventoryPane.selected = {};
end

function getTextWidth(txt)
  return getTextManager():MeasureStringX(UIFont.Small, getText(txt))
end

function ISInventoryPage:createChildren()
  
  local magicWidthNumber = 32

  self.minimumHeight = 100;
  self.minimumWidth = 256+magicWidthNumber;

  local titleBarHeight = self:titleBarHeight()
  local closeBtnSize = titleBarHeight
  local lootButtonHeight = titleBarHeight
  
  local buttonSpacing = 3
  local buttonPadding = 2
  
  
  local xferAllTextName = "IGUI_invpage_Transfer_all";
  local lootAllTextName = "IGUI_invpage_Loot_all";
  local dumpAllTextName = "IGUI_invpage_Dump_all";
  local removeAllTextName = "IGUI_invpage_RemoveAll";
  local contextMenuTurnOnTextName = "ContextMenu_Turn_On";

  local panel2 = ISInventoryPane:new(0, titleBarHeight, self.width-magicWidthNumber, self.height-titleBarHeight-9, self.inventory, self.zoom);
  panel2.anchorBottom = true;
  panel2.anchorRight = true;
  panel2.player = self.player;
  panel2:initialise();
  panel2:setMode("details");
  panel2.inventoryPage = self;
  self:addChild(panel2);

  self.inventoryPane = panel2;
  
  
  self.closeButton = ISButton:new(buttonSpacing, 0, closeBtnSize, closeBtnSize, "", self, ISInventoryPage.close);
  self.closeButton:initialise();
  self.closeButton.borderColor.a = 0.0;
  self.closeButton.backgroundColor.a = 0;
  self.closeButton.backgroundColorMouseOver.a = 0;
  self.closeButton:setImage(self.closebutton);
  self:addChild(self.closeButton);
  if getCore():getGameMode() == "Tutorial" then
    self.closeButton:setVisible(false)
  end

  self.infoButton = ISButton:new(self.closeButton:getRight() + buttonSpacing, 0, closeBtnSize, closeBtnSize, "", self, ISInventoryPage.onInfo);
  self.infoButton:initialise();
  self.infoButton.borderColor.a = 0.0;
  self.infoButton.backgroundColor.a = 0.0;
  self.infoButton.backgroundColorMouseOver.a = 0.7;
  self.infoButton:setImage(self.infoBtn);
  self:addChild(self.infoButton);
  self.infoButton:setVisible(false);
  
  

  self.transferAll = ISButton:new(self.infoButton:getRight() + buttonSpacing, 0, getTextWidth(xferAllTextName) + buttonPadding, lootButtonHeight, getText(xferAllTextName), self, ISInventoryPage.transferAll);
  self.transferAll:initialise();
  self.transferAll.borderColor.a = 0.0;
  self.transferAll.backgroundColor.a = 0.0;
  self.transferAll.backgroundColorMouseOver.a = 0.7;
  self:addChild(self.transferAll);
  self.transferAll:setVisible(false);

  if not self.onCharacter then
    
    
    self.lootAll = ISButton:new(self.infoButton:getRight() + buttonSpacing, 0, getTextWidth(lootAllTextName) + buttonPadding, lootButtonHeight, getText(lootAllTextName), self, ISInventoryPage.lootAll);
    self.lootAll:initialise();
    self.lootAll.borderColor.a = 0.0;
    self.lootAll.backgroundColor.a = 0.0;
    self.lootAll.backgroundColorMouseOver.a = 0.7;
    self:addChild(self.lootAll);
    self.lootAll:setVisible(false);
    
    
    -- (x, y, width, height, title, clicktarget, onclick, onmousedown, allowMouseUpProcessing)
    self.dumpAll = ISButton:new(self.lootAll:getRight() + buttonSpacing, 0, getTextWidth(dumpAllTextName) + buttonPadding, lootButtonHeight, getText(dumpAllTextName), self, ISInventoryPage.dumpAll);
    self.dumpAll:initialise();
    self.dumpAll.borderColor.a = 0.0;
    self.dumpAll.backgroundColor.a = 0.0;
    self.dumpAll.backgroundColorMouseOver.a = 0.7;
    self:addChild(self.dumpAll);
    self.dumpAll:setVisible(true);
    
    
    self.removeAll = ISButton:new(self.dumpAll:getRight() + buttonSpacing, 0, getTextWidth(removeAllTextName) + buttonPadding, lootButtonHeight, getText(removeAllTextName), self, ISInventoryPage.removeAll);
    self.removeAll:initialise();
    self.removeAll.borderColor.a = 0.0;
    self.removeAll.backgroundColor.a = 0.0;
    self.removeAll.backgroundColorMouseOver.a = 0.7;
    self:addChild(self.removeAll);
    self.removeAll:setVisible(false);

    self.toggleStove = ISButton:new(self.dumpAll:getRight() + buttonSpacing, 0, getTextWidth(contextMenuTurnOnTextName) + buttonPadding, lootButtonHeight, getText(contextMenuTurnOnTextName), self, ISInventoryPage.toggleStove);
    self.toggleStove:initialise();
    self.toggleStove.borderColor.a = 0.0;
    self.toggleStove.backgroundColor.a = 0.0;
    self.toggleStove.backgroundColorMouseOver.a = 0.7;
    self:addChild(self.toggleStove);
    self.toggleStove:setVisible(false);
  end



  local resizeWidget = ISResizeWidget:new(self.width-10, self.height-10, 10, 10, self);
  resizeWidget:initialise();
  self:addChild(resizeWidget);

  self.resizeWidget = resizeWidget;

  resizeWidget = ISResizeWidget:new(0, self.height-10, self.width-10, 10, self, true);
  resizeWidget.anchorLeft = true;
  resizeWidget.anchorRight = true;
  resizeWidget:initialise();
  self:addChild(resizeWidget);

  self.resizeWidget2 = resizeWidget;


  self.pinButton = ISButton:new(self.width - closeBtnSize - 3, 0, closeBtnSize, closeBtnSize, "", self, ISInventoryPage.setPinned);
  self.pinButton.anchorRight = true;
  self.pinButton.anchorLeft = false;
  self.pinButton:initialise();
  self.pinButton.borderColor.a = 0.0;
  self.pinButton.backgroundColor.a = 0;
  self.pinButton.backgroundColorMouseOver.a = 0;
  self.pinButton:setImage(self.pinbutton);
  self:addChild(self.pinButton);
  self.pinButton:setVisible(false);

  self.collapseButton = ISButton:new(self.pinButton:getX(), 0, closeBtnSize, closeBtnSize, "", self, ISInventoryPage.collapse);
  self.collapseButton.anchorRight = true;
  self.collapseButton.anchorLeft = false;
  self.collapseButton:initialise();
  self.collapseButton.borderColor.a = 0.0;
  self.collapseButton.backgroundColor.a = 0;
  self.collapseButton.backgroundColorMouseOver.a = 0;
  self.collapseButton:setImage(self.collapsebutton);
  self:addChild(self.collapseButton);
  if getCore():getGameMode() == "Tutorial" then
      self.collapseButton:setVisible(false);
  end
  -- load the current weight of the container
  self.totalWeight =  ISInventoryPage.loadWeight(self.inventory);

  self:refreshBackpacks();

  self:collapse();
end


function ISInventoryPage:dumpAll()
  self.inventoryPane:dumpAll();
end


