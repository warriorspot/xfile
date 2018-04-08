
PROGRAM "tearoff"
VERSION  "0.1"

IMPORT   "xst"   ' Standard library : required by most programs
IMPORT   "xgr"   ' GraphicsDesigner : required by GuiDesigner programs
IMPORT   "xui"   ' GuiDesigner      : required by GuiDesigner programs

'parent and v0 together uniquely identify the tearoff
TYPE TEAROFF
  XLONG .grid
  XLONG .parent
  XLONG .v0
  XLONG .wingrid
  FUNCADDR XLONG .callback(XLONG,XLONG,XLONG,XLONG,XLONG,XLONG, XLONG, ANY)
END TYPE

INTERNAL FUNCTION  Entry         ()
EXPORT
DECLARE FUNCTION  CreateTearOff (parent, kid, v0)
DECLARE FUNCTION  GetTearoffs(@grids[])
DECLARE FUNCTION  CloseTearoff(grid)
DECLARE FUNCTION  CloseAllTearoffs()
DECLARE FUNCTION  HideTearoff(grid)
DECLARE FUNCTION  ShowTearoff(grid)
END EXPORT
INTERNAL FUNCTION TearOffCallback(grid, message, v0, v1, v2, v3, kid, ANY)

SHARED TEAROFF Tearoffs[]


FUNCTION  Entry ()
  XgrMessageNameToNumber(@"Selection", @#Selection)
  XgrMessageNameToNumber(@"Callback", @#Callback)
  XgrMessageNameToNumber(@"CloseWindow", @#CloseWindow)
  IF LIBRARY(0) THEN RETURN        ' main program executes message loop
END FUNCTION

FUNCTION ShowTearoff(grid)
  XuiSendStringMessage(grid, @"DisplayWindow", 0,0,0,0,0,0)
END FUNCTION

FUNCTION HideTearoff(grid)
  XuiSendStringMessage(grid, @"HideWindow", 0,0,0,0,0,0)
END FUNCTION

FUNCTION GetTearoffs(@grids[])
  SHARED TEAROFF Tearoffs[]

  REDIM grids[]
  FOR i = 0 TO UBOUND(Tearoffs[])
    REDIM grids[i]
    grids[i] = Tearoffs[i].grid
  NEXT i
END FUNCTION

FUNCTION CloseAllTearoffs()
  SHARED TEAROFF Tearoffs[]

  FOR i = 0 TO UBOUND(Tearoffs[])
    XuiSendStringMessage(Tearoffs[i].grid, @"DestroyWindow", 0,0,0,0,0,0)
  NEXT i

  REDIM Tearoffs[]
END FUNCTION

FUNCTION  CreateTearOff (wingrid, kid, v0)
  SHARED TEAROFF Tearoffs[]

  XuiSendStringMessage(wingrid, @"GetGridNumber", @grid, 0,0,0, kid, 0)

  'Disallow multiple tearoffs
  FOR i = 0 TO UBOUND(Tearoffs[])
    IF(Tearoffs[i].parent == grid && Tearoffs[i].v0 == v0) THEN
      RETURN $$FALSE
    END IF
  NEXT i
  upper = UBOUND(Tearoffs[]) + 1
  REDIM Tearoffs[upper]

  XuiSendStringMessage(grid, @"GetTextArray", 0,0,0,0,1, @text$[])
  XuiSendStringMessage(grid, @"GetFontNumber", @font, 0,0,0,1,0)
  DO
    XstReplaceArray($$FindForward, @text$[], "_", "", @line, @pos, @match)
  LOOP WHILE match
  XuiSendStringMessage(wingrid, @"GetCallback", @foo, @callback, 0,0,0,0)
  XgrGetGridWindow(grid, @window)
  XgrGetWindowPositionAndSize(window, @x, @y, @w, @h)

  XuiCreateWindow(@g, @"XuiPullDown", x, y, 0, 0, $$WindowTypeTopMost | $$WindowTypeSystemMenu | $$WindowTypeTitleBar, "")
  XuiSendStringMessage ( g, @"SetCallback", g, &TearOffCallback(), v0, upper, kid, -1)
  XuiSendStringMessage ( g, @"SetWindowTitle", 0, 0, 0, 0, 0, @"Tearoff")
  XuiSendStringMessage ( g, @"SetGridName", 0, 0, 0, 0, 0, @"Tearoff")
  XuiSendStringMessage ( g, @"SetTextArray", 0,0,0,0, 0, @text$[])
  XuiSendStringMessage(g, @"SetBorder", $$BorderNone, $$BorderNone, $$BorderNone, $$BorderNone,0,0)
  XuiSendStringMessage(g, @"SetFontNumber", font, 0,0,0,0,0)
  XuiSendStringMessage(g, @"GetGridType", @gridType,0,0,0,0,0)
  XuiSetGridTypeProperty (gridType, @"can",              $$Respond OR $$Callback)
  XuiSendStringMessage ( g, @"DisplayWindow", 0, 0, 0, 0, 0, 0)
  XgrGetGridWindow(g, @window)
  XgrGetWindowPositionAndSize(window, 0, 0, @w, 0)
  XgrGetGridPositionAndSize(g, @x, @y, 0, @h)
  XgrSetGridPositionAndSize(g, x, y, w, h)

  Tearoffs[upper].grid = g
  Tearoffs[upper].parent = grid
  Tearoffs[upper].v0 = v0
  Tearoffs[upper].wingrid = wingrid
  Tearoffs[upper].callback = callback

  RETURN $$TRUE
END FUNCTION

FUNCTION TearOffCallback(grid, message, v0, v1, v2, v3, kid, r1)
  SHARED TEAROFF Tearoffs[]
  TEAROFF temp

  FOR i = 0 TO UBOUND(Tearoffs[])
    IF(Tearoffs[i].grid == grid) THEN
      temp = Tearoffs[i]
      EXIT FOR
    END IF
  NEXT i

  IF(message == #Callback) THEN message = r1

  SELECT CASE message
    CASE #Selection:
        IF(v0 == 0) THEN RETURN
        @temp.callback(temp.wingrid, #Callback, v2, v0, 0, 0, kid, #Selection)
    CASE #CloseWindow:
        CloseTearoff(temp.grid)
  END SELECT

END FUNCTION

FUNCTION CloseTearoff(grid)
   SHARED TEAROFF Tearoffs[]

    XuiSendStringMessage(grid, @"DestroyWindow", 0,0,0,0,0, 0)
    upper = UBOUND(Tearoffs[])
      IF(v3 == upper) THEN
         REDIM Tearoffs[upper - 1]
      RETURN
    END IF

    FOR i = 0 TO UBOUND(Tearoffs[])
      IF(Tearoffs[i].grid == grid) THEN
        FOR z = i TO UBOUND(Tearoffs[]) - 1
          Tearoffs[z] = Tearoffs[z + 1]
        NEXT z
        REDIM Tearoffs[UBOUND(Tearoffs[]) - 1]
        RETURN
      END IF
    NEXT i

END FUNCTION

END PROGRAM
