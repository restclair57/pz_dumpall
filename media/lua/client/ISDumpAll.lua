
function ISInventoryPane:dumpAll(player)
  -- print("hello ruby");
  
  
  local playerObj = getSpecificPlayer(self.player)
  local hotBar = getPlayerHotbar(self.player)
  local it = getPlayerLoot(self.player).inventory:getItems();
  local items = {}

  local toFloor = true
  for i = 0, it:size()-1 do
    local item = it:get(i);
    local ok = not item:isEquipped() and item:getType() ~= "KeyRing" and not hotBar:isInHotbar(item)
    if item:isFavorite() then
      ok = false
    end
    if toFloor and instanceof(item, "Moveable") and item:getSpriteGrid() == nil and not item:CanBeDroppedOnFloor() then
      ok = false
    end
    if ok then
      ISInventoryPaneContextMenu.dropItem(item, self.player)
    end
  end
  -- self:transferItemsByWeight(items, playerLoot)

  self.selected = {};
  getPlayerLoot(self.player).inventoryPane.selected = {};
  getPlayerInventory(self.player).inventoryPane.selected = {};
end



function ISInventoryPage:createChildren()

    self.minimumHeight = 100;
    -- This must be 32 pixels wider than InventoryPane's minimum width
    -- TODO: parent widgets respect min size of child widgets.
    self.minimumWidth = 256+32;

    local titleBarHeight = self:titleBarHeight()
    local closeBtnSize = titleBarHeight
    local lootButtonHeight = titleBarHeight

    local panel2 = ISInventoryPane:new(0, titleBarHeight, self.width-32, self.height-titleBarHeight-9, self.inventory, self.zoom);
    panel2.anchorBottom = true;
  panel2.anchorRight = true;
    panel2.player = self.player;
  panel2:initialise();

    panel2:setMode("details");

    panel2.inventoryPage = self;
  self:addChild(panel2);

  self.inventoryPane = panel2;

  -- FIXME: It is wrong to have both self.transferAll and ISInventoryPage.transferAll (button and function with the same name).
  print("OH HELLO THERE")
    local textWid = getTextManager():MeasureStringX(UIFont.Small, getText("IGUI_invpage_Transfer_all"))
    self.transferAll = ISButton:new(self.width - 3 - closeBtnSize - 90 - textWid, 0, textWid, lootButtonHeight, getText("IGUI_invpage_Transfer_all"), self, ISInventoryPage.transferAll);
    self.transferAll:initialise();
    self.transferAll.borderColor.a = 0.0;
    self.transferAll.backgroundColor.a = 0.0;
    self.transferAll.backgroundColorMouseOver.a = 0.7;
    self:addChild(self.transferAll);
    self.transferAll:setVisible(false);

    if not self.onCharacter then
      
      local cumulativeTextWidth = 4 + (closeBtnSize * 2)
      local buttonSpacerAmount = 32;
      
        self.lootAll = ISButton:new(cumulativeTextWidth, 0, 50, lootButtonHeight, getText("IGUI_invpage_Loot_all"), self, ISInventoryPage.lootAll);
        self.lootAll:initialise();
        self.lootAll.borderColor.a = 0.0;
        self.lootAll.backgroundColor.a = 0.0;
        self.lootAll.backgroundColorMouseOver.a = 0.7;
        self:addChild(self.lootAll);
        self.lootAll:setVisible(false);
        
        cumulativeTextWidth = cumulativeTextWidth + getTextManager():MeasureStringX(UIFont.Small, getText("IGUI_invpage_Loot_all")) + buttonSpacerAmount
        
        -- (x, y, width, height, title, clicktarget, onclick, onmousedown, allowMouseUpProcessing)
        self.dumpAll = ISButton:new(cumulativeTextWidth, 0, 50, lootButtonHeight, "Dump All", self, ISInventoryPage.dumpAll);
        self.dumpAll:initialise();
        self.dumpAll.borderColor.a = 0.0;
        self.dumpAll.backgroundColor.a = 0.0;
        self.dumpAll.backgroundColorMouseOver.a = 0.7;
        self:addChild(self.dumpAll);
        self.dumpAll:setVisible(true);
        
        
        cumulativeTextWidth = cumulativeTextWidth + getTextManager():MeasureStringX(UIFont.Small, "Dump All") + buttonSpacerAmount
        
        
        self.removeAll = ISButton:new(cumulativeTextWidth, 0, 50, lootButtonHeight, getText("IGUI_invpage_RemoveAll"), self, ISInventoryPage.removeAll);
        self.removeAll:initialise();
        self.removeAll.borderColor.a = 0.0;
        self.removeAll.backgroundColor.a = 0.0;
        self.removeAll.backgroundColorMouseOver.a = 0.7;
        self:addChild(self.removeAll);
        self.removeAll:setVisible(false);

        self.toggleStove = ISButton:new(cumulativeTextWidth, 0, 50, lootButtonHeight, getText("ContextMenu_Turn_On"), self, ISInventoryPage.toggleStove);
        self.toggleStove:initialise();
        self.toggleStove.borderColor.a = 0.0;
        self.toggleStove.backgroundColor.a = 0.0;
        self.toggleStove.backgroundColorMouseOver.a = 0.7;
        self:addChild(self.toggleStove);
        self.toggleStove:setVisible(false);
    end



    -- Do corner x + y widget
  local resizeWidget = ISResizeWidget:new(self.width-10, self.height-10, 10, 10, self);
  resizeWidget:initialise();
  self:addChild(resizeWidget);

  self.resizeWidget = resizeWidget;

    -- Do bottom y widget
    resizeWidget = ISResizeWidget:new(0, self.height-10, self.width-10, 10, self, true);
    resizeWidget.anchorLeft = true;
    resizeWidget.anchorRight = true;
    resizeWidget:initialise();
    self:addChild(resizeWidget);

    self.resizeWidget2 = resizeWidget;


    self.closeButton = ISButton:new(3, 0, closeBtnSize, closeBtnSize, "", self, ISInventoryPage.close);
    self.closeButton:initialise();
    self.closeButton.borderColor.a = 0.0;
    self.closeButton.backgroundColor.a = 0;
    self.closeButton.backgroundColorMouseOver.a = 0;
    self.closeButton:setImage(self.closebutton);
    self:addChild(self.closeButton);
    if getCore():getGameMode() == "Tutorial" then
        self.closeButton:setVisible(false)
    end

    self.infoButton = ISButton:new(self.closeButton:getRight() + 1, 0, closeBtnSize, closeBtnSize, "", self, ISInventoryPage.onInfo);
    self.infoButton:initialise();
    self.infoButton.borderColor.a = 0.0;
    self.infoButton.backgroundColor.a = 0.0;
    self.infoButton.backgroundColorMouseOver.a = 0.7;
    self.infoButton:setImage(self.infoBtn);
    self:addChild(self.infoButton);
    self.infoButton:setVisible(false);

    --  --print("adding pin button");
    self.pinButton = ISButton:new(self.width - closeBtnSize - 3, 0, closeBtnSize, closeBtnSize, "", self, ISInventoryPage.setPinned);
    self.pinButton.anchorRight = true;
    self.pinButton.anchorLeft = false;
  --  --print("initialising pin button");
    self.pinButton:initialise();
    self.pinButton.borderColor.a = 0.0;
    self.pinButton.backgroundColor.a = 0;
    self.pinButton.backgroundColorMouseOver.a = 0;
   -- --print("setting pin button image");
    self.pinButton:setImage(self.pinbutton);
  --  --print("adding pin button to panel");
    self:addChild(self.pinButton);
  --  --print("set pin button invisible.");
    self.pinButton:setVisible(false);

   -- --print("adding collapse button");
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

function ISInventoryPage:refreshWeight()
  return;
--~   for i,v in ipairs(self.backpacks) do
--~     v:setOverlayText(ISInventoryPage.loadWeight(v.inventory) .. "/" .. v.capacity);
--~   end
end


function ISInventoryPage:dumpAll()
  self.inventoryPane:dumpAll();
end


