PROGRAM  "xfile"
VERSION  "1.0"

IMPORT   "xst"
IMPORT   "xgr"
IMPORT   "xui"
IMPORT   "sqlite3"   'database support
IMPORT   "tokenize"  'string tokenizer
IMPORT   "tearoff"   'suport for tearoff menus
IMPORT   "user32"
IMPORT   "gdi32"

TYPE MODE
  XLONG .viewMode
  XLONG .findMode
  XLONG .markMode
  XLONG .exportMode
END TYPE

TYPE POINT
  XLONG .x
  XLONG .y
END TYPE

TYPE RECTANGLE
  POINT .start
  POINT .end
END TYPE

TYPE SEL_LIST
  XLONG .index
  XLONG .type
  XLONG .grid
END TYPE

TYPE FIELD
  XLONG .index
  XLONG .grid
  XLONG .grid_type
  XLONG .x
  XLONG .y
  XLONG .w
  XLONG .h
  XLONG .selected
  XLONG .visible
  XLONG .in_layout  'is this field in the current layout?
  XLONG .size
  XLONG .min  'this is used as width for images, summary type for summary fields
  XLONG .max  'this is used as height for images, field index for summary fields
  XLONG .type
  STRING * 32 .name
  STRING * 32 .image 'image name.  Will be loaded relative to project path
  STRING * 32 .fontName
  XLONG .fontSize
  XLONG .fontWeight
  XLONG .fontItalic
  XLONG .fontAngle
  XLONG .lowcolor
  XLONG .highcolor
  XLONG .textcolor
  XLONG .backcolor
  XLONG .border1
  XLONG .border2
  XLONG .border3
  XLONG .border4
  UNION
    GIANT    .int_min
    DOUBLE   .real_min
  END UNION
  UNION
    GIANT    .int_max
    DOUBLE   .real_max
  END UNION
END TYPE

TYPE RECORD
  XLONG       .id      'unique id for sqlite
  XLONG       .first
  XLONG       .last
  XLONG       .marked
  XLONG       .dirty    'user has modified and saved to memory, but not to db
  XLONG       .modified 'user has typed stuff, but its not saved anywhere
  XLONG       .new
  XLONG       .size 'in bytes
END TYPE

INTERNAL FUNCTION  Entry         ()
INTERNAL FUNCTION  InitGui       ()
INTERNAL FUNCTION  InitProgram   (XLONG)
INTERNAL FUNCTION  CreateWindows ()
INTERNAL FUNCTION  InitWindows   (XLONG)
INTERNAL FUNCTION  Create        (grid, message, v0, v1, v2, v3, r0, ANY)
INTERNAL FUNCTION  CreateCallback    (grid, message, v0, v1, v2, v3, kid, ANY)
INTERNAL FUNCTION  Note          (grid, message, v0, v1, v2, v3, r0, ANY)
INTERNAL FUNCTION  NoteCallback      (grid, message, v0, v1, v2, v3, kid, ANY)
INTERNAL FUNCTION  GeoFile       (grid, message, v0, v1, v2, v3, r0, ANY)
INTERNAL FUNCTION  GeoFileCode   (grid, message, v0, v1, v2, v3, kid, ANY)
INTERNAL FUNCTION  Organizer     (grid, message, v0, v1, v2, v3, r0, ANY)
INTERNAL FUNCTION  OrganizerCode (grid, message, v0, v1, v2, v3, kid, ANY)
INTERNAL FUNCTION  Record        (grid, message, v0, v1, v2, v3, r0, ANY)
INTERNAL FUNCTION  RecordCode    (grid, message, v0, v1, v2, v3, kid, ANY)
INTERNAL FUNCTION  FieldCallback    (grid, message, v0, v1, v2, v3, kid, ANY)
DECLARE FUNCTION  AddField (name$, type, size, resize, add_to_db, DOUBLE min, DOUBLE max)
DECLARE FUNCTION  GeoFileCEO (grid, message, v0, v1, v2, v3, r0, r1)
DECLARE FUNCTION  IsFieldSelected (grid, @index)
DECLARE FUNCTION  IsLabelSelected (grid, @index)
DECLARE FUNCTION  DrawSelectionRectangle (SEL_LIST list[])
DECLARE FUNCTION  UpdateCurrentRecord (grid)
DECLARE FUNCTION  SaveData ()
DECLARE FUNCTION  ClearFields ()
DECLARE FUNCTION  GetIndexByRecordNumber (record, @first, @last)
DECLARE FUNCTION  DisplayRecord (record, update)
DECLARE FUNCTION  AddRecord (@record, new, id)
DECLARE FUNCTION  SaveRecord (record)
DECLARE FUNCTION  GetFilename (@name$, @attributes)
DECLARE FUNCTION  GetFieldByGrid (grid, @index)
DECLARE FUNCTION  CheckFieldName (name$)
DECLARE FUNCTION  GetFieldByName (name$, @index)
DECLARE CFUNCTION  SQLCallback (void, argc, argv, columns)
DECLARE FUNCTION  ReadDatabaseFile (file$)
DECLARE FUNCTION  ReadGeoFile (file$)
DECLARE FUNCTION  GetNextRecord (@record, option)
DECLARE FUNCTION  GetPreviousRecord (@record, option)
DECLARE FUNCTION  GetFirstRecord (@record, option)
DECLARE FUNCTION  GetLastRecord (@record, option)
DECLARE FUNCTION  AddRecordData (record, index, @data$)
DECLARE FUNCTION  ResizeRecords (record_size, index, first, last)
INTERNAL FUNCTION  Export (grid, message, v0, v1, v2, v3, r0, ANY)
INTERNAL FUNCTION  ExportCode (grid, message, v0, v1, v2, v3, r0, ANY)
INTERNAL FUNCTION  MarkRecords   (grid, message, v0, v1, v2, v3, r0, ANY)
INTERNAL FUNCTION  MarkRecordsCode (grid, message, v0, v1, v2, v3, kid, ANY)
DECLARE FUNCTION  FindRecordByString (data$, @record, direction, ignore, partial, field, opt, include)
INTERNAL FUNCTION  Find          (grid, message, v0, v1, v2, v3, r0, ANY)
INTERNAL FUNCTION  FindCode      (grid, message, v0, v1, v2, v3, kid, ANY)
DECLARE FUNCTION  MarkRecord (record, state)
DECLARE FUNCTION  CreateProject ()
DECLARE FUNCTION  SaveLayout (layout$)
DECLARE FUNCTION  GetLabelByGrid (grid, @index)
DECLARE FUNCTION  LoadLayout (layout$, resize, load_fields)
DECLARE FUNCTION  Select (message, @r0)
DECLARE FUNCTION  GetSelectedFields (POINT, POINT, SEL_LIST list[])
DECLARE FUNCTION  IsRectInRect (RECTANGLE, RECTANGLE)
DECLARE FUNCTION  GetFieldSR (FIELD, RECTANGLE)
DECLARE FUNCTION  MoveSelectedObjects (SEL_LIST list[], POINT delta)
DECLARE FUNCTION  CheckSelListByGrid (SEL_LIST list[], grid)
DECLARE FUNCTION  CheckSelListByIndex (SEL_LIST list[], index)
DECLARE FUNCTION  AdjustRect (POINT, POINT)
DECLARE FUNCTION  MoveAllObjects (x, y)
DECLARE FUNCTION  GetFieldNames (@names$[])
DECLARE FUNCTION  SQL_AddTable (@name$)
DECLARE FUNCTION  SQL_CreateDatabase (@fqname$, @dbname$)
DECLARE FUNCTION  CreateGeoFile (@db$, @table$)
DECLARE FUNCTION  SQL_AddColumn (@name$, type, len)
DECLARE FUNCTION  GetNextRecordId ()
DECLARE FUNCTION  CloseProject (prompt, quitting)
DECLARE FUNCTION  OpenProject (file$)
DECLARE FUNCTION  ExportRecords (file$, type, mode)
DECLARE FUNCTION  IsFieldVisible (FIELD)
DECLARE FUNCTION  ImportRecords (file$, type)
DECLARE FUNCTION  LoadFields (layout$, resize)
DECLARE FUNCTION  GetDirtyRecords (@records[])
DECLARE FUNCTION  AddImage (x1, y1, x2, y2, new, @file$)
DECLARE FUNCTION  SaveRecords(@records[])
DECLARE FUNCTION  SetVisibility (SEL_LIST @sel_list[])
DECLARE FUNCTION  SetBackgroundImage (file$, modified)
DECLARE FUNCTION  AddLabel (name$, x, y, w, h, auto, @label_width)
DECLARE FUNCTION  SetImage (grid, index, record, prompt)
DECLARE FUNCTION  MarkAllRecords (option, state)
DECLARE FUNCTION  GetFields (check, @fields[])
DECLARE FUNCTION  GetLabels (check, @labels[])
DECLARE FUNCTION  SQL_DeleteColumn (column$)
DECLARE FUNCTION  DeleteField (index)
DECLARE FUNCTION  DeleteLabel (index)
DECLARE FUNCTION  DeleteRecord (record)
DECLARE FUNCTION  SQL_ClearTable ()
DECLARE FUNCTION  ClearRecord (record)
DECLARE FUNCTION  AskYesNo (msg$)
DECLARE FUNCTION  DeleteMarkedRecords (@count, @err)
DECLARE FUNCTION  GetNextViewableRecord (record)
DECLARE FUNCTION  GetMarkedRecords (@records[])
DECLARE FUNCTION  DestroyGrid (grid)
INTERNAL FUNCTION  Confirm       (grid, message, v0, v1, v2, v3, r0, ANY)
INTERNAL FUNCTION  ConfirmCode   (grid, message, v0, v1, v2, v3, kid, ANY)
INTERNAL FUNCTION  Message       (grid, message, v0, v1, v2, v3, r0, ANY)
INTERNAL FUNCTION  MessageCode   (grid, message, v0, v1, v2, v3, kid, ANY)
INTERNAL FUNCTION  File          (grid, message, v0, v1, v2, v3, r0, ANY)
INTERNAL FUNCTION  FileCode      (grid, message, v0, v1, v2, v3, kid, ANY)
DECLARE FUNCTION  ShowMessage (@msg$)
DECLARE FUNCTION GetModeString (@mode$)
INTERNAL FUNCTION  FieldProperties (grid, message, v0, v1, v2, v3, r0, ANY)
INTERNAL FUNCTION  FieldPropertiesCode (grid, message, v0, v1, v2, v3, kid, ANY)
DECLARE FUNCTION  GetRecord (order_index)
DECLARE FUNCTION  GetOrderIndex (record)
INTERNAL FUNCTION  Sort          (grid, message, v0, v1, v2, v3, r0, ANY)
INTERNAL FUNCTION  SortCode      (grid, message, v0, v1, v2, v3, kid, ANY)
DECLARE FUNCTION  GetFieldData (index, @data$[])
DECLARE FUNCTION  ResetRecordOrder ()
DECLARE FUNCTION  DeleteOrderIndex (record)
DECLARE FUNCTION  Log (level, msg$)
INTERNAL FUNCTION  XFile         (grid, message, v0, v1, v2, v3, r0, ANY)
INTERNAL FUNCTION  XFileCode     (grid, message, v0, v1, v2, v3, kid, ANY)
DECLARE FUNCTION  AddFreeLabel ()
DECLARE FUNCTION  GlobalCEO (grid, message, v0, v1, v2, v3, r0, ANY)
DECLARE FUNCTION  CreateLayout ()
DECLARE FUNCTION  GetLayouts (@out$[])
INTERNAL FUNCTION  Layout        (grid, message, v0, v1, v2, v3, r0, ANY)
INTERNAL FUNCTION  LayoutCode    (grid, message, v0, v1, v2, v3, kid, ANY)
INTERNAL FUNCTION  ListView        (grid, message, v0, v1, v2, v3, r0, ANY)
INTERNAL FUNCTION  ListViewCode    (grid, message, v0, v1, v2, v3, kid, ANY)
DECLARE FUNCTION  RemoveFromLayout (index, type)
DECLARE FUNCTION  AddToLayout (index, type)
DECLARE FUNCTION  ClearCanvas ()
INTERNAL FUNCTION  Arrange       (grid, message, v0, v1, v2, v3, r0, ANY)
INTERNAL FUNCTION  ArrangeCode   (grid, message, v0, v1, v2, v3, kid, ANY)
DECLARE FUNCTION  MoveObject (grid, index, type, POINT)
DECLARE FUNCTION  Blink (timer, @count, msec, time)
INTERNAL FUNCTION  ModifyPage    (grid, message, v0, v1, v2, v3, r0, ANY)
INTERNAL FUNCTION  ModifyPageCode (grid, message, v0, v1, v2, v3, kid, ANY)
DECLARE FUNCTION  UpdateSummaryField (index)
DECLARE FUNCTION  CenterWindow (grid)
DECLARE FUNCTION  UpdateLayouts (new, index)
DECLARE FUNCTION  GetLabelByName (name$, index)
INTERNAL FUNCTION  Bump          (grid, message, v0, v1, v2, v3, r0, ANY)
INTERNAL FUNCTION  BumpCode      (grid, message, v0, v1, v2, v3, kid, ANY)
DECLARE FUNCTION  ResizePage (w, h)
DECLARE FUNCTION  CopyImageFile (file$, @name$, move)
DECLARE FUNCTION  MakeFieldVisible (index, type)
DECLARE FUNCTION  DrawRuler (action, mode)
DECLARE FUNCTION  UpdateRuler (action, check_mouse)
DECLARE FUNCTION  SlideShow(timer, @count, msec, time)
INTERNAL FUNCTION  FieldOrder    (grid, message, v0, v1, v2, v3, r0, ANY)
INTERNAL FUNCTION  FieldOrderCode (grid, message, v0, v1, v2, v3, kid, ANY)
DECLARE FUNCTION  SQL_ReorderColumns (columns$[])
DECLARE FUNCTION DeleteSelectedLabels(SEL_LIST list[])
DECLARE FUNCTION QuitProgram()
DECLARE FUNCTION ResizeField(index, step, which)
DECLARE FUNCTION EvaluateExpression(exp$[])
INTERNAL FUNCTION  ExpressionBuilderCode (grid, message, v0, v1, v2, v3, kid, ANY)
INTERNAL FUNCTION  ExpressionBuilder (grid, message, v0, v1, v2, v3, kid, ANY)
DECLARE FUNCTION GetSummaryField(index, @field)
DECLARE FUNCTION  GetWeekOfYear (year, month, day)
DECLARE FUNCTION ConvertImage(@file$, @converted)
DECLARE FUNCTION InsertDate()
DECLARE FUNCTION GetNextField(in, @out, dir, labels)
DECLARE FUNCTION ReadConfigFile(file$)
INTERNAL FUNCTION  Configuration (grid, message, v0, v1, v2, v3, r0, ANY)
INTERNAL FUNCTION  ConfigurationCode (grid, message, v0, v1, v2, v3, kid, ANY)
DECLARE FUNCTION CombineFieldLists(FIELD a[], FIELD b[], FIELD list[])
DECLARE FUNCTION UpdateShowMarked(record)
DECLARE FUNCTION Help ()
DECLARE FUNCTION ExportHTML (file$, mode)
DECLARE FUNCTION RunExternalTool(tool$)

$$DOWN = 0
$$UP = 1

'Image conversion
$$IMG_CONVERTER$ = "C:\\xfile\\tools\\pvw32con.exe"

'Ruler
$$RULER_DRAW = 0
$$RULER_CLEAR = 1
$$RULER_DRAW_BOX = 3
$$RULER_DRAW_GRID = 2

$$RULER_MODE_INCHES = 0
$$RULER_MODE_CM = 1
$$RULER_MODE_PX = 2

$$RULER_COLOR = $$Green
$$RULER_CARET_COLOR = $$Yellow
$$RULER_TICK_COLOR = $$Black
$$RULER_TEXT_COLOR = $$Blue

'Logging
$$LOG_DEBUG = 0
$$LOG_INFO = 1
$$LOG_ERROR = 2

'Mode constants for view, find, mark, export
$$MARK_APPEND = 0
$$MARK_REPLACE = 1
$$FIND_ALL = 0
$$FIND_MARKED = 1
$$VIEW_ALL = 0
$$VIEW_MARKED = 1
$$EXPORT_ALL = 1
$$EXPORT_MARKED = 2
$$EXPORT_CURRENT = 3

'Options for GetFields() and GetLabels
$$FIELDS_VISIBLE = 0
$$FIELDS_NOT_VISIBLE = 1
$$FIELDS_IN_LAYOUT = 2
$$FIELDS_NOT_IN_LAYOUT = 3

'Export type
$$EXPORT_CSV = 1
$$EXPORT_BMP = 2
$$EXPORT_HTML = 3

'Import type
$$IMPORT_CSV = 1

'This must match the kid number of the canvas grid in GeoFile
$$CANVAS_GRID = 3

'Field default values
$$FIELD_HEIGHT_SINGLE = 20
$$FIELD_HEIGHT_MULTI = 80
$$FIELD_WIDTH = 200
$$FIELD_HEIGHT_IMAGE = 50
$$FIELD_WIDTH_IMAGE = 50

'Field Data Types
$$FT_NONE = -1
$$FT_STRING_SINGLE = 0
$$FT_STRING_MULTI = 1
$$FT_INTEGER = 2
$$FT_REAL = 3
$$FT_DATE = 4
$$FT_SUMMARY = 5
$$FT_IMAGE = 6

'Object grid types
' $$ENTRY and $$IMAGE are data fields, and user modifiable
' so they go into FieldList
' $$LABEL and $$STATIC_IMAGE or static display objects,
' so they go into LabelList
$$LABEL = 0
$$ENTRY = 1
$$IMAGE = 2
$$STATIC_IMAGE = 3

$$MAX_FIELD_NAME_LENGTH = 24
$$MAX_FIELD_LENGTH = 512
$$DEFAULT_STRING_SIZE = 64
$$DEFAULT_NUM_SIZE = 32

'Database command constants
$$DB_READ_TABLE = 1
$$DB_CREATE_TABLE = 2
$$DB_CREATE_COLUMN = 3
$$DB_READ_DATA = 4
$$DB_DELETE_COLUMN = 5
$$DB_CLEAR = 6
$$DB_REORDER_COLUMNS = 7

'String constants
$$SQL_INDEX_COLUMN$ = "geofile_id"
$$STATIC_IMAGE_DIR$ = "images"
$$MAIN_TITLE$ = "XFile"
$$CONSOLE_TITLE$ = "XFile Console"

'Mouse Modes
$$NONE = -1
$$SELECTION = 0
$$CIRCLE = 1
$$RECTANGLE = 2
$$LINE = 3
$$TEXT = 4

$$MENU_SPACE = 5

$$IMAGE_COLOR = $$LightGrey

'Options for MarkAllRecords()
$$MARK = 0
$$SWITCH = 1

'Option for GetNext/Previous/First/LastRecord()
$$GET_MARKED = 1
$$GET_ORDINAL = 2

$$DELIMITERS$ = " ,.?!@\"':=+-();//<>"
$$DATE_DELIMITERS$ = "//-."
$$TEAROFF$ = "\t <--------< "

'Summary field types
$$SUM_TYPE_TOTAL = 0
$$SUM_TYPE_AVERAGE = 1
$$SUM_TYPE_MIN = 2
$$SUM_TYPE_MAX = 3

'The real important shared arrays
'Other shard variables are initialized in InitProgram
SHARED FIELD FieldList[]
SHARED FIELD LabelList[]
'Used to combine the field and label lists.
SHARED FIELD ObjectList[]
SHARED RECORD RecordList[]
SHARED SEL_LIST SelList[]
'Order of record indexes
SHARED XLONG RecordOrder[]

'Global string data (no length limit)
SHARED StringData$[]
SHARED Layouts$[]

SHARED MODE Mode

' ######################
' #####  Entry ()  #####
' ######################
'
FUNCTION  Entry ()
   SHARED  terminateProgram
   STATIC   entry

   IF entry THEN RETURN
   entry =  $$TRUE

   #StartingProgram = $$TRUE
   XstClearConsole()
   InitGui ()
   InitProgram ($$TRUE)
   CreateWindows ()
   InitWindows ($$TRUE)
   #StartingProgram = $$FALSE

   DO
      XgrProcessMessages (1)
   LOOP UNTIL terminateProgram
END FUNCTION

' ########################
' #####  InitGui ()  #####
' ########################
'
' InitGui() initializes cursor, icon, message, and display variables.
' Programs can reference these variables, but must never change them.
'
FUNCTION  InitGui ()
   program$ = PROGRAM$(0)
   XstSetProgramName (@program$)
   XgrRegisterCursor (@"default",      @#cursorDefault)
   XgrRegisterCursor (@"arrow",        @#cursorArrow)
   XgrRegisterCursor (@"n",            @#cursorN)
   XgrRegisterCursor (@"s",            @#cursorS)
   XgrRegisterCursor (@"e",            @#cursorE)
   XgrRegisterCursor (@"w",            @#cursorW)
   XgrRegisterCursor (@"ns",           @#cursorArrowsNS)
   XgrRegisterCursor (@"ns",           @#cursorArrowsSN)
   XgrRegisterCursor (@"ew",           @#cursorArrowsEW)
   XgrRegisterCursor (@"ew",           @#cursorArrowsWE)
   XgrRegisterCursor (@"nwse",         @#cursorArrowsNWSE)
   XgrRegisterCursor (@"nesw",         @#cursorArrowsNESW)
   XgrRegisterCursor (@"all",          @#cursorArrowsAll)
   XgrRegisterCursor (@"plus",         @#cursorPlus)
   XgrRegisterCursor (@"wait",         @#cursorWait)
   XgrRegisterCursor (@"insert",       @#cursorInsert)
   XgrRegisterCursor (@"crosshair",    @#cursorCrosshair)
   XgrRegisterCursor (@"hourglass",    @#cursorHourglass)
   XgrRegisterCursor (@"hand",         @#cursorHand)
   XgrRegisterCursor (@"help",         @#cursorHelp)
   #defaultCursor = #cursorDefault
   XgrRegisterIcon (@"hand",              @#iconHand)
   XgrRegisterIcon (@"asterisk",       @#iconAsterisk)
   XgrRegisterIcon (@"question",       @#iconQuestion)
   XgrRegisterIcon (@"exclamation", @#iconExclamation)
   XgrRegisterIcon (@"application", @#iconApplication)
   XgrRegisterIcon (@"hand",              @#iconStop)
   XgrRegisterIcon (@"asterisk",       @#iconInformation)
   XgrRegisterIcon (@"application",  @#iconBlank)
   XgrRegisterIcon (@"window",            @#iconWindow)
   XgrRegisterMessage (@"Blowback",                            @#Blowback)
   XgrRegisterMessage (@"Callback",                            @#Callback)
   XgrRegisterMessage (@"Cancel",                                 @#Cancel)
   XgrRegisterMessage (@"Change",                                 @#Change)
   XgrRegisterMessage (@"CloseWindow",                         @#CloseWindow)
   XgrRegisterMessage (@"ContextChange",                       @#ContextChange)
   XgrRegisterMessage (@"Create",                                 @#Create)
   XgrRegisterMessage (@"CreateValueArray",                 @#CreateValueArray)
   XgrRegisterMessage (@"CreateWindow",                        @#CreateWindow)
   XgrRegisterMessage (@"CursorH",                                @#CursorH)
   XgrRegisterMessage (@"CursorV",                                @#CursorV)
   XgrRegisterMessage (@"Deselected",                          @#Deselected)
   XgrRegisterMessage (@"Destroy",                                @#Destroy)
   XgrRegisterMessage (@"Destroyed",                              @#Destroyed)
   XgrRegisterMessage (@"DestroyWindow",                       @#DestroyWindow)
   XgrRegisterMessage (@"Disable",                                @#Disable)
   XgrRegisterMessage (@"Disabled",                            @#Disabled)
   XgrRegisterMessage (@"Displayed",                              @#Displayed)
   XgrRegisterMessage (@"DisplayWindow",                       @#DisplayWindow)
   XgrRegisterMessage (@"Enable",                                 @#Enable)
   XgrRegisterMessage (@"Enabled",                                @#Enabled)
   XgrRegisterMessage (@"Enter",                                  @#Enter)
   XgrRegisterMessage (@"ExitMessageLoop",                     @#ExitMessageLoop)
   XgrRegisterMessage (@"Find",                                   @#Find)
   XgrRegisterMessage (@"FindForward",                         @#FindForward)
   XgrRegisterMessage (@"FindReverse",                         @#FindReverse)
   XgrRegisterMessage (@"Forward",                                @#Forward)
   XgrRegisterMessage (@"GetAlign",                            @#GetAlign)
   XgrRegisterMessage (@"GetBorder",                              @#GetBorder)
   XgrRegisterMessage (@"GetBorderOffset",                     @#GetBorderOffset)
   XgrRegisterMessage (@"GetCallback",                         @#GetCallback)
   XgrRegisterMessage (@"GetCallbackArgs",                     @#GetCallbackArgs)
   XgrRegisterMessage (@"GetCan",                                 @#GetCan)
   XgrRegisterMessage (@"GetCharacterMapArray",          @#GetCharacterMapArray)
   XgrRegisterMessage (@"GetCharacterMapEntry",          @#GetCharacterMapEntry)
   XgrRegisterMessage (@"GetClipGrid",                         @#GetClipGrid)
   XgrRegisterMessage (@"GetColor",                            @#GetColor)
   XgrRegisterMessage (@"GetColorExtra",                       @#GetColorExtra)
   XgrRegisterMessage (@"GetCursor",                              @#GetCursor)
   XgrRegisterMessage (@"GetCursorXY",                         @#GetCursorXY)
   XgrRegisterMessage (@"GetDisplay",                          @#GetDisplay)
   XgrRegisterMessage (@"GetEnclosedGrids",                 @#GetEnclosedGrids)
   XgrRegisterMessage (@"GetEnclosingGrid",                 @#GetEnclosingGrid)
   XgrRegisterMessage (@"GetFocusColor",                       @#GetFocusColor)
   XgrRegisterMessage (@"GetFocusColorExtra",               @#GetFocusColorExtra)
   XgrRegisterMessage (@"GetFont",                                @#GetFont)
   XgrRegisterMessage (@"GetFontMetrics",                   @#GetFontMetrics)
   XgrRegisterMessage (@"GetFontNumber",                       @#GetFontNumber)
   XgrRegisterMessage (@"GetGridFunction",                     @#GetGridFunction)
   XgrRegisterMessage (@"GetGridFunctionName",              @#GetGridFunctionName)
   XgrRegisterMessage (@"GetGridName",                         @#GetGridName)
   XgrRegisterMessage (@"GetGridNumber",                       @#GetGridNumber)
   XgrRegisterMessage (@"GetGridProperties",                @#GetGridProperties)
   XgrRegisterMessage (@"GetGridType",                         @#GetGridType)
   XgrRegisterMessage (@"GetGridTypeName",                     @#GetGridTypeName)
   XgrRegisterMessage (@"GetGroup",                            @#GetGroup)
   XgrRegisterMessage (@"GetHelp",                                @#GetHelp)
   XgrRegisterMessage (@"GetHelpFile",                         @#GetHelpFile)
   XgrRegisterMessage (@"GetHelpString",                       @#GetHelpString)
   XgrRegisterMessage (@"GetHelpStrings",                   @#GetHelpStrings)
   XgrRegisterMessage (@"GetHintString",                       @#GetHintString)
   XgrRegisterMessage (@"GetImage",                            @#GetImage)
   XgrRegisterMessage (@"GetImageCoords",                   @#GetImageCoords)
   XgrRegisterMessage (@"GetIndent",                              @#GetIndent)
   XgrRegisterMessage (@"GetInfo",                                @#GetInfo)
   XgrRegisterMessage (@"GetJustify",                          @#GetJustify)
   XgrRegisterMessage (@"GetKeyboardFocus",                 @#GetKeyboardFocus)
   XgrRegisterMessage (@"GetKeyboardFocusGrid",          @#GetKeyboardFocusGrid)
   XgrRegisterMessage (@"GetKidArray",                         @#GetKidArray)
   XgrRegisterMessage (@"GetKidNumber",                        @#GetKidNumber)
   XgrRegisterMessage (@"GetKids",                                @#GetKids)
   XgrRegisterMessage (@"GetKind",                                @#GetKind)
   XgrRegisterMessage (@"GetMaxMinSize",                       @#GetMaxMinSize)
   XgrRegisterMessage (@"GetMenuEntryArray",                @#GetMenuEntryArray)
   XgrRegisterMessage (@"GetMessageFunc",                   @#GetMessageFunc)
   XgrRegisterMessage (@"GetMessageFuncArray",              @#GetMessageFuncArray)
   XgrRegisterMessage (@"GetMessageSub",                       @#GetMessageSub)
   XgrRegisterMessage (@"GetMessageSubArray",               @#GetMessageSubArray)
   XgrRegisterMessage (@"GetModalInfo",                        @#GetModalInfo)
   XgrRegisterMessage (@"GetModalWindow",                   @#GetModalWindow)
   XgrRegisterMessage (@"GetParent",                              @#GetParent)
   XgrRegisterMessage (@"GetPosition",                         @#GetPosition)
   XgrRegisterMessage (@"GetProtoInfo",                        @#GetProtoInfo)
   XgrRegisterMessage (@"GetRedrawFlags",                   @#GetRedrawFlags)
   XgrRegisterMessage (@"GetSize",                                @#GetSize)
   XgrRegisterMessage (@"GetSmallestSize",                     @#GetSmallestSize)
   XgrRegisterMessage (@"GetState",                            @#GetState)
   XgrRegisterMessage (@"GetStyle",                            @#GetStyle)
   XgrRegisterMessage (@"GetTabArray",                         @#GetTabArray)
   XgrRegisterMessage (@"GetTabWidth",                         @#GetTabWidth)
   XgrRegisterMessage (@"GetTextArray",                        @#GetTextArray)
   XgrRegisterMessage (@"GetTextArrayBounds",               @#GetTextArrayBounds)
   XgrRegisterMessage (@"GetTextArrayLine",                 @#GetTextArrayLine)
   XgrRegisterMessage (@"GetTextArrayLines",                @#GetTextArrayLines)
   XgrRegisterMessage (@"GetTextCursor",                       @#GetTextCursor)
   XgrRegisterMessage (@"GetTextFilename",                     @#GetTextFilename)
   XgrRegisterMessage (@"GetTextPosition",                     @#GetTextPosition)
   XgrRegisterMessage (@"GetTextSelection",                 @#GetTextSelection)
   XgrRegisterMessage (@"GetTextSpacing",                   @#GetTextSpacing)
   XgrRegisterMessage (@"GetTextString",                       @#GetTextString)
   XgrRegisterMessage (@"GetTextStrings",                   @#GetTextStrings)
   XgrRegisterMessage (@"GetTexture",                          @#GetTexture)
   XgrRegisterMessage (@"GetTimer",                            @#GetTimer)
   XgrRegisterMessage (@"GetValue",                            @#GetValue)
   XgrRegisterMessage (@"GetValueArray",                       @#GetValueArray)
   XgrRegisterMessage (@"GetValues",                              @#GetValues)
   XgrRegisterMessage (@"GetWindow",                              @#GetWindow)
   XgrRegisterMessage (@"GetWindowFunction",                @#GetWindowFunction)
   XgrRegisterMessage (@"GetWindowGrid",                       @#GetWindowGrid)
   XgrRegisterMessage (@"GetWindowIcon",                       @#GetWindowIcon)
   XgrRegisterMessage (@"GetWindowSize",                       @#GetWindowSize)
   XgrRegisterMessage (@"GetWindowTitle",                   @#GetWindowTitle)
   XgrRegisterMessage (@"GotKeyboardFocus",                 @#GotKeyboardFocus)
   XgrRegisterMessage (@"GrabArray",                              @#GrabArray)
   XgrRegisterMessage (@"GrabTextArray",                       @#GrabTextArray)
   XgrRegisterMessage (@"GrabTextString",                   @#GrabTextString)
   XgrRegisterMessage (@"GrabValueArray",                   @#GrabValueArray)
   XgrRegisterMessage (@"Help",                                   @#Help)
   XgrRegisterMessage (@"Hidden",                                 @#Hidden)
   XgrRegisterMessage (@"HideTextCursor",                   @#HideTextCursor)
   XgrRegisterMessage (@"HideWindow",                          @#HideWindow)
   XgrRegisterMessage (@"Initialize",                          @#Initialize)
   XgrRegisterMessage (@"Initialized",                         @#Initialized)
   XgrRegisterMessage (@"Inline",                                 @#Inline)
   XgrRegisterMessage (@"InquireText",                         @#InquireText)
   XgrRegisterMessage (@"KeyboardFocusBackward",            @#KeyboardFocusBackward)
   XgrRegisterMessage (@"KeyboardFocusForward",          @#KeyboardFocusForward)
   XgrRegisterMessage (@"KeyDown",                                @#KeyDown)
   XgrRegisterMessage (@"KeyUp",                                  @#KeyUp)
   XgrRegisterMessage (@"LostKeyboardFocus",                @#LostKeyboardFocus)
   XgrRegisterMessage (@"LostTextSelection",                @#LostTextSelection)
   XgrRegisterMessage (@"Maximized",                              @#Maximized)
   XgrRegisterMessage (@"MaximizeWindow",                   @#MaximizeWindow)
   XgrRegisterMessage (@"Maximum",                                @#Maximum)
   XgrRegisterMessage (@"Minimized",                              @#Minimized)
   XgrRegisterMessage (@"MinimizeWindow",                   @#MinimizeWindow)
   XgrRegisterMessage (@"Minimum",                                @#Minimum)
   XgrRegisterMessage (@"MonitorContext",                   @#MonitorContext)
   XgrRegisterMessage (@"MonitorHelp",                         @#MonitorHelp)
   XgrRegisterMessage (@"MonitorKeyboard",                     @#MonitorKeyboard)
   XgrRegisterMessage (@"MonitorMouse",                        @#MonitorMouse)
   XgrRegisterMessage (@"MouseDown",                              @#MouseDown)
   XgrRegisterMessage (@"MouseDrag",                              @#MouseDrag)
   XgrRegisterMessage (@"MouseEnter",                          @#MouseEnter)
   XgrRegisterMessage (@"MouseExit",                              @#MouseExit)
   XgrRegisterMessage (@"MouseMove",                              @#MouseMove)
   XgrRegisterMessage (@"MouseUp",                                @#MouseUp)
   XgrRegisterMessage (@"MouseWheel",                          @#MouseWheel)
   XgrRegisterMessage (@"MuchLess",                            @#MuchLess)
   XgrRegisterMessage (@"MuchMore",                            @#MuchMore)
   XgrRegisterMessage (@"Notify",                                 @#Notify)
   XgrRegisterMessage (@"OneLess",                                @#OneLess)
   XgrRegisterMessage (@"OneMore",                                @#OneMore)
   XgrRegisterMessage (@"PokeArray",                              @#PokeArray)
   XgrRegisterMessage (@"PokeTextArray",                       @#PokeTextArray)
   XgrRegisterMessage (@"PokeTextString",                   @#PokeTextString)
   XgrRegisterMessage (@"PokeValueArray",                   @#PokeValueArray)
   XgrRegisterMessage (@"Print",                                  @#Print)
   XgrRegisterMessage (@"Redraw",                                 @#Redraw)
   XgrRegisterMessage (@"RedrawGrid",                          @#RedrawGrid)
   XgrRegisterMessage (@"RedrawLines",                         @#RedrawLines)
   XgrRegisterMessage (@"Redrawn",                                @#Redrawn)
   XgrRegisterMessage (@"RedrawText",                          @#RedrawText)
   XgrRegisterMessage (@"RedrawWindow",                        @#RedrawWindow)
   XgrRegisterMessage (@"Replace",                                @#Replace)
   XgrRegisterMessage (@"ReplaceForward",                   @#ReplaceForward)
   XgrRegisterMessage (@"ReplaceReverse",                   @#ReplaceReverse)
   XgrRegisterMessage (@"Reset",                                  @#Reset)
   XgrRegisterMessage (@"Resize",                                 @#Resize)
   XgrRegisterMessage (@"Resized",                                @#Resized)
   XgrRegisterMessage (@"ResizeNot",                              @#ResizeNot)
   XgrRegisterMessage (@"ResizeWindow",                        @#ResizeWindow)
   XgrRegisterMessage (@"ResizeWindowToGrid",               @#ResizeWindowToGrid)
   XgrRegisterMessage (@"Resized",                                @#Resized)
   XgrRegisterMessage (@"Reverse",                                @#Reverse)
   XgrRegisterMessage (@"ScrollH",                                @#ScrollH)
   XgrRegisterMessage (@"ScrollV",                                @#ScrollV)
   XgrRegisterMessage (@"Select",                                 @#Select)
   XgrRegisterMessage (@"Selected",                            @#Selected)
   XgrRegisterMessage (@"Selection",                              @#Selection)
   XgrRegisterMessage (@"SelectWindow",                        @#SelectWindow)
   XgrRegisterMessage (@"SetAlign",                            @#SetAlign)
   XgrRegisterMessage (@"SetBorder",                              @#SetBorder)
   XgrRegisterMessage (@"SetBorderOffset",                     @#SetBorderOffset)
   XgrRegisterMessage (@"SetCallback",                         @#SetCallback)
   XgrRegisterMessage (@"SetCan",                                 @#SetCan)
   XgrRegisterMessage (@"SetCharacterMapArray",          @#SetCharacterMapArray)
   XgrRegisterMessage (@"SetCharacterMapEntry",          @#SetCharacterMapEntry)
   XgrRegisterMessage (@"SetClipGrid",                         @#SetClipGrid)
   XgrRegisterMessage (@"SetColor",                            @#SetColor)
   XgrRegisterMessage (@"SetColorAll",                         @#SetColorAll)
   XgrRegisterMessage (@"SetColorExtra",                       @#SetColorExtra)
   XgrRegisterMessage (@"SetColorExtraAll",                 @#SetColorExtraAll)
   XgrRegisterMessage (@"SetCursor",                              @#SetCursor)
   XgrRegisterMessage (@"SetCursorXY",                         @#SetCursorXY)
   XgrRegisterMessage (@"SetDisplay",                          @#SetDisplay)
   XgrRegisterMessage (@"SetFocusColor",                       @#SetFocusColor)
   XgrRegisterMessage (@"SetFocusColorExtra",               @#SetFocusColorExtra)
   XgrRegisterMessage (@"SetFont",                                @#SetFont)
   XgrRegisterMessage (@"SetFontNumber",                       @#SetFontNumber)
   XgrRegisterMessage (@"SetGridFunction",                     @#SetGridFunction)
   XgrRegisterMessage (@"SetGridFunctionName",              @#SetGridFunctionName)
   XgrRegisterMessage (@"SetGridName",                         @#SetGridName)
   XgrRegisterMessage (@"SetGridProperties",                @#SetGridProperties)
   XgrRegisterMessage (@"SetGridType",                         @#SetGridType)
   XgrRegisterMessage (@"SetGridTypeName",                     @#SetGridTypeName)
   XgrRegisterMessage (@"SetGroup",                            @#SetGroup)
   XgrRegisterMessage (@"SetHelp",                                @#SetHelp)
   XgrRegisterMessage (@"SetHelpFile",                         @#SetHelpFile)
   XgrRegisterMessage (@"SetHelpString",                       @#SetHelpString)
   XgrRegisterMessage (@"SetHelpStrings",                   @#SetHelpStrings)
   XgrRegisterMessage (@"SetHintString",                       @#SetHintString)
   XgrRegisterMessage (@"SetImage",                            @#SetImage)
   XgrRegisterMessage (@"SetImageCoords",                   @#SetImageCoords)
   XgrRegisterMessage (@"SetIndent",                              @#SetIndent)
   XgrRegisterMessage (@"SetInfo",                                @#SetInfo)
   XgrRegisterMessage (@"SetJustify",                          @#SetJustify)
   XgrRegisterMessage (@"SetKeyboardFocus",                 @#SetKeyboardFocus)
   XgrRegisterMessage (@"SetKeyboardFocusGrid",          @#SetKeyboardFocusGrid)
   XgrRegisterMessage (@"SetKidArray",                         @#SetKidArray)
   XgrRegisterMessage (@"SetMaxMinSize",                       @#SetMaxMinSize)
   XgrRegisterMessage (@"SetMenuEntryArray",                @#SetMenuEntryArray)
   XgrRegisterMessage (@"SetMessageFunc",                   @#SetMessageFunc)
   XgrRegisterMessage (@"SetMessageFuncArray",              @#SetMessageFuncArray)
   XgrRegisterMessage (@"SetMessageSub",                       @#SetMessageSub)
   XgrRegisterMessage (@"SetMessageSubArray",               @#SetMessageSubArray)
   XgrRegisterMessage (@"SetModalWindow",                   @#SetModalWindow)
   XgrRegisterMessage (@"SetParent",                              @#SetParent)
   XgrRegisterMessage (@"SetPosition",                         @#SetPosition)
   XgrRegisterMessage (@"SetRedrawFlags",                   @#SetRedrawFlags)
   XgrRegisterMessage (@"SetSize",                                @#SetSize)
   XgrRegisterMessage (@"SetState",                            @#SetState)
   XgrRegisterMessage (@"SetStyle",                            @#SetStyle)
   XgrRegisterMessage (@"SetTabArray",                         @#SetTabArray)
   XgrRegisterMessage (@"SetTabWidth",                         @#SetTabWidth)
   XgrRegisterMessage (@"SetTextArray",                        @#SetTextArray)
   XgrRegisterMessage (@"SetTextArrayLine",                 @#SetTextArrayLine)
   XgrRegisterMessage (@"SetTextArrayLines",                @#SetTextArrayLines)
   XgrRegisterMessage (@"SetTextCursor",                       @#SetTextCursor)
   XgrRegisterMessage (@"SetTextFilename",                     @#SetTextFilename)
   XgrRegisterMessage (@"SetTextSelection",                 @#SetTextSelection)
   XgrRegisterMessage (@"SetTextSpacing",                   @#SetTextSpacing)
   XgrRegisterMessage (@"SetTextString",                       @#SetTextString)
   XgrRegisterMessage (@"SetTextStrings",                   @#SetTextStrings)
   XgrRegisterMessage (@"SetTexture",                          @#SetTexture)
   XgrRegisterMessage (@"SetTimer",                            @#SetTimer)
   XgrRegisterMessage (@"SetValue",                            @#SetValue)
   XgrRegisterMessage (@"SetValues",                              @#SetValues)
   XgrRegisterMessage (@"SetValueArray",                       @#SetValueArray)
   XgrRegisterMessage (@"SetWindowFunction",                @#SetWindowFunction)
   XgrRegisterMessage (@"SetWindowIcon",                       @#SetWindowIcon)
   XgrRegisterMessage (@"SetWindowTitle",                   @#SetWindowTitle)
   XgrRegisterMessage (@"ShowTextCursor",                   @#ShowTextCursor)
   XgrRegisterMessage (@"ShowWindow",                          @#ShowWindow)
   XgrRegisterMessage (@"SomeLess",                            @#SomeLess)
   XgrRegisterMessage (@"SomeMore",                            @#SomeMore)
   XgrRegisterMessage (@"StartTimer",                          @#StartTimer)
   XgrRegisterMessage (@"SystemMessage",                       @#SystemMessage)
   XgrRegisterMessage (@"TextDelete",                          @#TextDelete)
   XgrRegisterMessage (@"TextEvent",                              @#TextEvent)
   XgrRegisterMessage (@"TextInsert",                          @#TextInsert)
   XgrRegisterMessage (@"TextModified",                        @#TextModified)
   XgrRegisterMessage (@"TextReplace",                         @#TextReplace)
   XgrRegisterMessage (@"TimeOut",                                @#TimeOut)
   XgrRegisterMessage (@"Update",                                 @#Update)
   XgrRegisterMessage (@"WindowClose",                         @#WindowClose)
   XgrRegisterMessage (@"WindowCreate",                        @#WindowCreate)
   XgrRegisterMessage (@"WindowDeselected",                 @#WindowDeselected)
   XgrRegisterMessage (@"WindowDestroy",                       @#WindowDestroy)
   XgrRegisterMessage (@"WindowDestroyed",                     @#WindowDestroyed)
   XgrRegisterMessage (@"WindowDisplay",                       @#WindowDisplay)
   XgrRegisterMessage (@"WindowDisplayed",                     @#WindowDisplayed)
   XgrRegisterMessage (@"WindowGetDisplay",                 @#WindowGetDisplay)
   XgrRegisterMessage (@"WindowGetFunction",                @#WindowGetFunction)
   XgrRegisterMessage (@"WindowGetIcon",                       @#WindowGetIcon)
   XgrRegisterMessage (@"WindowGetKeyboardFocusGrid", @#WindowGetKeyboardFocusGrid)
   XgrRegisterMessage (@"WindowGetSelectedWindow",       @#WindowGetSelectedWindow)
   XgrRegisterMessage (@"WindowGetSize",                       @#WindowGetSize)
   XgrRegisterMessage (@"WindowGetTitle",                   @#WindowGetTitle)
   XgrRegisterMessage (@"WindowHelp",                          @#WindowHelp)
   XgrRegisterMessage (@"WindowHide",                          @#WindowHide)
   XgrRegisterMessage (@"WindowHidden",                        @#WindowHidden)
   XgrRegisterMessage (@"WindowKeyDown",                       @#WindowKeyDown)
   XgrRegisterMessage (@"WindowKeyUp",                         @#WindowKeyUp)
   XgrRegisterMessage (@"WindowMaximize",                   @#WindowMaximize)
   XgrRegisterMessage (@"WindowMaximized",                     @#WindowMaximized)
   XgrRegisterMessage (@"WindowMinimize",                   @#WindowMinimize)
   XgrRegisterMessage (@"WindowMinimized",                     @#WindowMinimized)
   XgrRegisterMessage (@"WindowMonitorContext",          @#WindowMonitorContext)
   XgrRegisterMessage (@"WindowMonitorHelp",                @#WindowMonitorHelp)
   XgrRegisterMessage (@"WindowMonitorKeyboard",            @#WindowMonitorKeyboard)
   XgrRegisterMessage (@"WindowMonitorMouse",               @#WindowMonitorMouse)
   XgrRegisterMessage (@"WindowMouseDown",                     @#WindowMouseDown)
   XgrRegisterMessage (@"WindowMouseDrag",                     @#WindowMouseDrag)
   XgrRegisterMessage (@"WindowMouseEnter",                 @#WindowMouseEnter)
   XgrRegisterMessage (@"WindowMouseExit",                     @#WindowMouseExit)
   XgrRegisterMessage (@"WindowMouseMove",                     @#WindowMouseMove)
   XgrRegisterMessage (@"WindowMouseUp",                       @#WindowMouseUp)
   XgrRegisterMessage (@"WindowMouseWheel",                 @#WindowMouseWheel)
   XgrRegisterMessage (@"WindowRedraw",                        @#WindowRedraw)
   XgrRegisterMessage (@"WindowRegister",                   @#WindowRegister)
   XgrRegisterMessage (@"WindowResize",                        @#WindowResize)
   XgrRegisterMessage (@"WindowResized",                       @#WindowResized)
   XgrRegisterMessage (@"WindowResizeToGrid",               @#WindowResizeToGrid)
   XgrRegisterMessage (@"WindowSelect",                        @#WindowSelect)
   XgrRegisterMessage (@"WindowSelected",                   @#WindowSelected)
   XgrRegisterMessage (@"WindowSetFunction",                @#WindowSetFunction)
   XgrRegisterMessage (@"WindowSetIcon",                       @#WindowSetIcon)
   XgrRegisterMessage (@"WindowSetKeyboardFocusGrid", @#WindowSetKeyboardFocusGrid)
   XgrRegisterMessage (@"WindowSetTitle",                   @#WindowSetTitle)
   XgrRegisterMessage (@"WindowShow",                          @#WindowShow)
   XgrRegisterMessage (@"WindowSystemMessage",              @#WindowSystemMessage)
   XgrRegisterMessage (@"LastMessage",                         @#LastMessage)
   XgrGetDisplaySize ("", @#displayWidth, @#displayHeight, @#windowBorderWidth, @#windowTitleHeight)
END FUNCTION

' ############################
' #####  InitProgram ()  #####
' ############################
'
' Initialize GLOBALS and other stuff
'
FUNCTION  InitProgram (first)
  SHARED FIELD FieldList[]
  SHARED RECORD RecordList[]
  SHARED FIELD LabelList[]
  SHARED StringData$[]
  SHARED SEL_LIST SelList[]
  SHARED MODE Mode
  SHARED Layouts$[]

  Mode.viewMode = $$VIEW_ALL
  Mode.markMode = $$MARK_REPLACE
  Mode.findMode = $$FIND_ALL
  Mode.exportMode = $$EXPORT_ALL

  XstGetOSName(@#OS$)
  #OS$ = LCASE$(#OS$)
  IF(INSTR(#OS$, "linux")) THEN
    #Linux = $$TRUE
  ELSE
    #Linux = $$FALSE
  END IF

  #GeoFile$ = ""

  #SelectedGrid = 0
  #CurrentRecord = -1
  #MaxRecord = -1
  #DesignMode = $$TRUE
  #DataFile$ = ""
  #TableName$ = ""
  #ColumnCount = 0
  #ShowOnlyMarked = $$FALSE
  #DB = 0
  #FirstField = $$FALSE
  #LayoutModified = $$FALSE
  #PrintActive = $$FALSE

  #DefaultLayout$ = "default.frm"
  #CurrentLayout$ = #DefaultLayout$
  #CurrentProject$ = ""
  IF(#Linux) THEN
    #ProjectDirectory$ = "~/xfile/"
  ELSE
    #ProjectDirectory$ = "C:\\xfile\\"
  END IF
  #ConfigFile$ = #ProjectDirectory$ + "xfile.cfg"
  XstSetCurrentDirectory(@#ProjectDirectory$)
  'Cant remember why I wanted this
  XstGetCurrentDirectory(@#XFileDirectory$)
  'Current background image
  #BackgroundImage$ = ""
  #CANVAS_COLOR = $$White
  #UpdateSummaryFields = $$TRUE
  'Slide show active?
  #SlideShow = $$FALSE
  #SlideShowTimer = 0

  IF(first) THEN
    'These are controlled by the config file
    'These defaults will be used if they
    'are not found in the config file,
    'or there is some error in the config file.
    #DEBUG = $$TRUE
    #ShowConsole = $$TRUE
    #BitmapEditor$ = ""
    #HTMLViewer$ = ""
    #SlideShowDelay = 3
    #NoScrollbars = $$TRUE
    ReadConfigFile(#ConfigFile$)

    #MouseMode = $$NONE
    #RulerMode = $$RULER_MODE_INCHES
    #Timer = 0
    DIM #Buff[]
    DIM #Buff$[]
    DIM #Buff#[]
    DIM #Buff$$[]
    DIM FieldList[]
    DIM LabelList[]
    DIM RecordList[]
    DIM StringData$[]
    DIM SelList[]
    DIM Layouts$[0]
    Layouts$[0] = #DefaultLayout$
    XgrSetCEO(&GlobalCEO())
    #CanvasGrid = 0
    #CanvasGridBuffer = 0
    #IllegalFieldNameChars$ = ", \".;:[]{}!@#$%^&*()=+|\'~`?/<>-"
    #SplashActive = $$TRUE
  ELSE
    XstKillTimer(#Timer)
    #Timer = 0
    REDIM Layouts$[]
    REDIM #Buff[]
    REDIM #Buff$[]
    REDIM #Buff#[]
    REDIM #Buff$$[]
    REDIM FieldList[]
    REDIM LabelList[]
    REDIM RecordList[]
    REDIM StringData$[]
    REDIM SelList[]
    #SplashActive = $$FALSE
  END IF

END FUNCTION

' ##############################
' #####  CreateWindows ()  #####
' ##############################
'
FUNCTION  CreateWindows ()
   Create         (@Create, #CreateWindow, 0, 0, 0, 0, $$WindowTypeTopMost | $$WindowTypeTitleBar, 0)
   XuiSendMessage ( Create, #SetCallback, Create, &CreateCallback(), -1, -1, -1, 0)
   XuiSendMessage ( Create, #Initialize, 0, 0, 0, 0, 0, 0)
   XuiSendMessage ( Create, #SetGridProperties, -1, 0, 0, 0, 0, 0)
   #CreateField = Create

   Note           (@Note, #CreateWindow, 0, 0, 0, 0, 0, 0)
   XuiSendMessage ( Note, #SetCallback, Note, &NoteCallback(), -1, -1, -1, 0)
   XuiSendMessage ( Note, #Initialize, 0, 0, 0, 0, 0, 0)
   XuiSendMessage ( Note, #SetGridProperties, -1, 0, 0, 0, 0, 0)
   #Note = Note

   GeoFile        (@GeoFile, #CreateWindow, 0, 0, 0, 0, 0, 0)
   XuiSendMessage ( GeoFile, #SetCallback, GeoFile, &GeoFileCode(), -1, -1, -1, 0)
   XuiSendMessage ( GeoFile, #Initialize, 0, 0, 0, 0, 0, 0)
   'XuiSendMessage ( GeoFile, #DisplayWindow, 0, 0, 0, 0, 0, 0)
   XuiSendMessage ( GeoFile, #SetGridProperties, -1, 0, 0, 0, 0, 0)
   #GeoFile = GeoFile

   Organizer      (@Organizer, #CreateWindow, 0, 0, 0, 0, $$WindowTypeTopMost | $$WindowTypeTitleBar, 0)
   XuiSendMessage ( Organizer, #SetCallback, Organizer, &OrganizerCode(), -1, -1, -1, 0)
   XuiSendMessage ( Organizer, #Initialize, 0, 0, 0, 0, 0, 0)
   XuiSendMessage ( Organizer, #SetGridProperties, -1, 0, 0, 0, 0, 0)
   #Organizer = Organizer

   Record         (@Record, #CreateWindow, 0, 0, 0, 0, $$WindowTypeTopMost | $$WindowTypeTitleBar, 0)
   XuiSendMessage ( Record, #SetCallback, Record, &RecordCode(), -1, -1, -1, 0)
   XuiSendMessage ( Record, #Initialize, 0, 0, 0, 0, 0, 0)
   XuiSendMessage ( Record, #SetGridProperties, -1, 0, 0, 0, 0, 0)
   #Record = Record

   MarkRecords    (@MarkRecords, #CreateWindow, 0, 0, 0, 0, $$WindowTypeModal | $$WindowTypeTitleBar, 0)
   XuiSendMessage ( MarkRecords, #SetCallback, MarkRecords, &MarkRecordsCode(), -1, -1, -1, 0)
   XuiSendMessage ( MarkRecords, #Initialize, 0, 0, 0, 0, 0, 0)
   XuiSendMessage ( MarkRecords, #SetGridProperties, -1, 0, 0, 0, 0, 0)
   #MarkRecords = MarkRecords

   Find           (@Find, #CreateWindow, 0, 0, 0, 0, 0, 0)
   XuiSendMessage ( Find, #SetCallback, Find, &FindCode(), -1, -1, -1, 0)
   XuiSendMessage ( Find, #Initialize, 0, 0, 0, 0, 0, 0)
   XuiSendMessage ( Find, #SetGridProperties, -1, 0, 0, 0, 0, 0)
  #Find = Find

   Confirm        (@Confirm, #CreateWindow, 0, 0, 0, 0, $$WindowTypeModal | $$WindowTypeTitleBar, 0)
   XuiSendMessage ( Confirm, #SetCallback, Confirm, &ConfirmCode(), -1, -1, -1, 0)
   XuiSendMessage ( Confirm, #Initialize, 0, 0, 0, 0, 0, 0)
   XuiSendMessage ( Confirm, #SetGridProperties, -1, 0, 0, 0, 0, 0)
   #Confirm = Confirm

   Message        (@Message, #CreateWindow, 0, 0, 0, 0, $$WindowTypeModal | $$WindowTypeTitleBar , 0)
   XuiSendMessage ( Message, #SetCallback, Message, &MessageCode(), -1, -1, -1, 0)
   XuiSendMessage ( Message, #Initialize, 0, 0, 0, 0, 0, 0)
   XuiSendMessage ( Message, #SetGridProperties, -1, 0, 0, 0, 0, 0)
   #Message = Message

   File        (@File, #CreateWindow, 0, 0, 0, 0, $$WindowTypeModal | $$WindowTypeTitleBar | $$WindowTypeTopMost, 0)
   XuiSendMessage ( File, #SetCallback, File, &FileCode(), -1, -1, -1, 0)
   XuiSendMessage ( File, #Initialize, 0, 0, 0, 0, 0, 0)
   XuiSendMessage ( File, #SetGridProperties, -1, 0, 0, 0, 0, 0)
  #File = File

   FieldProperties (@FieldProperties, #CreateWindow, 0, 0, 0, 0, 0, 0)
   XuiSendMessage ( FieldProperties, #SetCallback, FieldProperties, &FieldPropertiesCode(), -1, -1, -1, 0)
   XuiSendMessage ( FieldProperties, #Initialize, 0, 0, 0, 0, 0, 0)
   XuiSendMessage ( FieldProperties, #SetGridProperties, -1, 0, 0, 0, 0, 0)
   #FieldProperties = FieldProperties

   Sort           (@Sort, #CreateWindow, 0, 0, 0, 0, 0, 0)
   XuiSendMessage ( Sort, #SetCallback, Sort, &SortCode(), -1, -1, -1, 0)
   XuiSendMessage ( Sort, #Initialize, 0, 0, 0, 0, 0, 0)
   XuiSendMessage ( Sort, #SetGridProperties, -1, 0, 0, 0, 0, 0)
   #Sort = Sort

   XFile          (@XFile, #CreateWindow, 0, 0, 0, 0, $$WindowTypeModal | $$WindowTypeTitleBar, 0)
   XuiSendMessage ( XFile, #SetCallback, XFile, &XFileCode(), -1, -1, -1, 0)
   XuiSendMessage ( XFile, #Initialize, 0, 0, 0, 0, 0, 0)
   XuiSendMessage ( XFile, #SetGridProperties, -1, 0, 0, 0, 0, 0)
   #XFile = XFile

   Layout         (@Layout, #CreateWindow, 0, 0, 0, 0, 0, 0)
   XuiSendMessage ( Layout, #SetCallback, Layout, &LayoutCode(), -1, -1, -1, 0)
   XuiSendMessage ( Layout, #Initialize, 0, 0, 0, 0, 0, 0)
   XuiSendMessage ( Layout, #SetGridProperties, -1, 0, 0, 0, 0, 0)
   #Layout = Layout

   Arrange        (@Arrange, #CreateWindow, 0, 0, 0, 0, 0, 0)
   XuiSendMessage ( Arrange, #SetCallback, Arrange, &ArrangeCode(), -1, -1, -1, 0)
   XuiSendMessage ( Arrange, #Initialize, 0, 0, 0, 0, 0, 0)
   XuiSendMessage ( Arrange, #SetGridProperties, -1, 0, 0, 0, 0, 0)
   #Arrange = Arrange

   ModifyPage     (@ModifyPage, #CreateWindow, 0, 0, 0, 0, 0, 0)
   XuiSendMessage ( ModifyPage, #SetCallback, ModifyPage, &ModifyPageCode(), -1, -1, -1, 0)
   XuiSendMessage ( ModifyPage, #Initialize, 0, 0, 0, 0, 0, 0)
   XuiSendMessage ( ModifyPage, #SetGridProperties, -1, 0, 0, 0, 0, 0)
   #ModifyPage = ModifyPage

   Bump           (@Bump, #CreateWindow, 0, 0, 0, 0, 0, 0)
   XuiSendMessage ( Bump, #SetCallback, Bump, &BumpCode(), -1, -1, -1, 0)
   XuiSendMessage ( Bump, #Initialize, 0, 0, 0, 0, 0, 0)
   XuiSendMessage ( Bump, #SetGridProperties, -1, 0, 0, 0, 0, 0)
   #Bump = Bump
'
	FieldOrder     (@FieldOrder, #CreateWindow, 0, 0, 0, 0, 0, 0)
	XuiSendMessage ( FieldOrder, #SetCallback, FieldOrder, &FieldOrderCode(), -1, -1, -1, 0)
	XuiSendMessage ( FieldOrder, #Initialize, 0, 0, 0, 0, 0, 0)
	XuiSendMessage ( FieldOrder, #SetGridProperties, -1, 0, 0, 0, 0, 0)
	#FieldOrder = FieldOrder

  Export         ( @Export, #CreateWindow, 0, 0, 0, 0, 0, 0)
	XuiSendMessage ( Export, #SetCallback, Export, &ExportCode(), -1, -1, -1, 0)
	XuiSendMessage ( Export, #Initialize, 0, 0, 0, 0, 0, 0)
	XuiSendMessage ( Export, #SetGridProperties, -1, 0, 0, 0, 0, 0)
	#Export = Export

  ExpressionBuilder (@ExpressionBuilder, #CreateWindow, 0, 0, 0, 0, 0, 0)
	XuiSendMessage ( ExpressionBuilder, #SetCallback, ExpressionBuilder, &ExpressionBuilderCode(), -1, -1, -1, 0)
	XuiSendMessage ( ExpressionBuilder, #Initialize, 0, 0, 0, 0, 0, 0)
	XuiSendMessage ( ExpressionBuilder, #SetGridProperties, -1, 0, 0, 0, 0, 0)
  #ExpressionBuilder = ExpressionBuilder

  Configuration  (@Configuration, #CreateWindow, 0, 0, 0, 0, 0, 0)
	XuiSendMessage ( Configuration, #SetCallback, Configuration, &ConfigurationCode(), -1, -1, -1, 0)
	XuiSendMessage ( Configuration, #Initialize, 0, 0, 0, 0, 0, 0)
	XuiSendMessage ( Configuration, #SetGridProperties, -1, 0, 0, 0, 0, 0)
	#Configuration = Configuration

  ListView       (@ListView, #CreateWindow, 0, 0, 0, 0, 0, 0)
	XuiSendMessage ( ListView, #SetCallback, ListView, &ListViewCode(), -1, -1, -1, 0)
	XuiSendMessage ( ListView, #Initialize, 0, 0, 0, 0, 0, 0)
	XuiSendMessage ( ListView, #SetGridProperties, -1, 0, 0, 0, 0, 0)
	#ListView = ListView
END FUNCTION


' ############################
' #####  InitWindows ()  #####
' ############################
'
FUNCTION  InitWindows (first)
   $xrbHighlight     =   7
   $xpbSortAscending  =   6
   $xrRecord        =   7

  IF(first) THEN

    'Get Window numbers
    XgrGetGridWindow(#GeoFile, @#GeoFileWin)
    XgrGetGridWindow(#Record, @#RecordWin)
    XgrGetGridWindow(#Organizer, @#OrganizerWin)

    'Set application-wide fonts
    XuiGetKidArray(#Configuration, #GetKidArray, 0, 0, 0,0,0, @kids[])
    FOR i = 0 TO UBOUND(kids[])
      XuiSendMessage ( kids[i], #SetFont, 240, 1000, 0, 0, 0, @"MS Sans Serif")
    NEXT i
    XuiGetKidArray(#Export, #GetKidArray, 0, 0, 0,0,0, @kids[])
    FOR i = 0 TO UBOUND(kids[])
      XuiSendMessage ( kids[i], #SetFont, 240, 1000, 0, 0, 0, @"MS Sans Serif")
    NEXT i
    XuiGetKidArray(#ExpressionBuilder, #GetKidArray, 0, 0, 0,0,0, @kids[])
    FOR i = 0 TO UBOUND(kids[])
      XuiSendMessage ( kids[i], #SetFont, 240, 1000, 0, 0, 0, @"MS Sans Serif")
    NEXT i
    XuiGetKidArray(#CreateField, #GetKidArray, 0, 0, 0,0,0, @kids[])
    FOR i = 0 TO UBOUND(kids[])
      XuiSendMessage ( kids[i], #SetFont, 240, 1000, 0, 0, 0, @"MS Sans Serif")
    NEXT i
    XuiGetKidArray(#Organizer, #GetKidArray, 0, 0, 0,0,0, @kids[])
    FOR i = 0 TO UBOUND(kids[])
      XuiSendMessage ( kids[i], #SetFont, 240, 1000, 0, 0, 0, @"MS Sans Serif")
    NEXT i
    XuiGetKidArray(#Record, #GetKidArray, 0, 0, 0,0,0, @kids[])
    FOR i = 0 TO UBOUND(kids[])
      XuiSendMessage ( kids[i], #SetFont, 240, 1000, 0, 0, 0, @"MS Sans Serif")
    NEXT i
    XuiGetKidArray(#Find, #GetKidArray, 0, 0, 0,0,0, @kids[])
    FOR i = 0 TO UBOUND(kids[])
      XuiSendMessage ( kids[i], #SetFont, 240, 1000, 0, 0, 0, @"MS Sans Serif")
    NEXT i
    XuiGetKidArray(#MarkRecords, #GetKidArray, 0, 0, 0,0,0, @kids[])
    FOR i = 0 TO UBOUND(kids[])
      XuiSendMessage ( kids[i], #SetFont, 240, 1000, 0, 0, 0, @"MS Sans Serif")
    NEXT i
    XuiGetKidArray(#FieldOrder, #GetKidArray, 0, 0, 0,0,0, @kids[])
    FOR i = 0 TO UBOUND(kids[])
      XuiSendMessage ( kids[i], #SetFont, 240, 1000, 0, 0, 0, @"MS Sans Serif")
    NEXT i
    XuiGetKidArray(#FieldProperties, #GetKidArray, 0, 0, 0,0,0, @kids[])
    FOR i = 0 TO UBOUND(kids[])
      XuiSendMessage ( kids[i], #SetFont, 240, 1000, 0, 0, 0, @"MS Sans Serif")
    NEXT i
    XuiGetKidArray(#Confirm, #GetKidArray, 0, 0, 0,0,0, @kids[])
    FOR i = 0 TO UBOUND(kids[])
      XuiSendMessage ( kids[i], #SetFont, 240, 1000, 0, 0, 0, @"MS Sans Serif")
    NEXT i
    XuiGetKidArray(#Message, #GetKidArray, 0, 0, 0,0,0, @kids[])
    FOR i = 0 TO UBOUND(kids[])
      XuiSendMessage ( kids[i], #SetFont, 240, 1000, 0, 0, 0, @"MS Sans Serif")
    NEXT i
    XuiGetKidArray(#File, #GetKidArray, 0, 0, 0,0,0, @kids[])
    FOR i = 0 TO UBOUND(kids[])
      XuiSendMessage ( kids[i], #SetFont, 240, 1000, 0, 0, 0, @"MS Sans Serif")
    NEXT i
    XuiGetKidArray(#Sort, #GetKidArray, 0, 0, 0,0,0, @kids[])
    FOR i = 0 TO UBOUND(kids[])
      XuiSendMessage ( kids[i], #SetFont, 240, 1000, 0, 0, 0, @"MS Sans Serif")
    NEXT i
    XuiGetKidArray(#Layout, #GetKidArray, 0, 0, 0,0,0, @kids[])
    FOR i = 0 TO UBOUND(kids[])
      XuiSendMessage ( kids[i], #SetFont, 240, 1000, 0, 0, 0, @"MS Sans Serif")
    NEXT i
    XuiGetKidArray(#Arrange, #GetKidArray, 0, 0, 0,0,0, @kids[])
    FOR i = 0 TO UBOUND(kids[])
      XuiSendMessage ( kids[i], #SetFont, 240, 1000, 0, 0, 0, @"MS Sans Serif")
    NEXT i
    XuiGetKidArray(#ModifyPage, #GetKidArray, 0, 0, 0,0,0, @kids[])
    FOR i = 0 TO UBOUND(kids[])
      XuiSendMessage ( kids[i], #SetFont, 240, 1000, 0, 0, 0, @"MS Sans Serif")
    NEXT i
    XuiGetKidArray(#ListView, #GetKidArray, 0, 0, 0,0,0, @kids[])
    FOR i = 0 TO UBOUND(kids[])
      XuiSendMessage ( kids[i], #SetFont, 240, 1000, 0, 0, 0, @"MS Sans Serif")
    NEXT i

    'Determine DPI
    display$ = "DISPLAY"
    dc = CreateDCA(&display$, 0, 0, 0)
    #DPI_X = GetDeviceCaps(dc, $$LOGPIXELSX)
    #DPI_Y = GetDeviceCaps(dc, $$LOGPIXELSY)
    DeleteDC(dc)

    'Get important grid numbers
    XuiGetGridNumber(#GeoFile, #GetGridNumber, @#CanvasGrid, 0,0,0, $$CANVAS_GRID, 0)
    XuiGetGridNumber(#GeoFile, #GetGridNumber, @#CanvasGridClip, 0,0,0, $$CANVAS_GRID - 1, 0)
    XuiSendMessage (#CanvasGridClip, #SetFont, 240, 250, 0, 0, 0, @"MS Sans Serif")

    'Set up ruler constants
    XgrGetGridPositionAndSize(#CanvasGridClip, @x, @y,0,0)
    XgrGetGridPositionAndSize(#CanvasGrid, @x1,@y1, 0,0)
    #RulerWidth = x1 - x - 1
    #RulerHeight = y1 - y - 1
  END IF

  'Center the window
  CenterWindow(#GeoFile)

  XgrAddMessage(#Sort, #Callback, $$TRUE,0,0,0, $xpbSortAscending, #Selection)
  XgrAddMessage(#FieldProperties, #Callback, 0,0,0,0, $xrbHighlight, #Selection)
  XuiSendMessage(#Record, #SetValue, 0, 0,0,0,$xrRecord,0)
  XuiSendMessage(#GeoFile, #Disable, 0,0,0,0,20,0)

  XgrGetGridPositionAndSize(#CanvasGrid, 0, 0, @w, @h)
  #PageWidth = w
  #PageHeight = h
  #buffX = 0
  #buffY = 0

  IF(first) THEN
    XgrGetGridWindow(#CanvasGrid, @window)
    XgrCreateGrid(@#CanvasGridBuffer, 1, 0, 0, w, h, window, #CanvasGrid, 0)
    XgrClearGrid(#CanvasGridBuffer, #CANVAS_COLOR)
    XgrSetGridBuffer(#CanvasGrid, #CanvasGridBuffer, #buffX, #buffY)
    XgrSetGridClip(#CanvasGrid, #CanvasGridClip)
    XgrSetGridClip(#CanvasGridBuffer, #CanvasGridClip)
    XgrClearGrid(#CanvasGrid, #CANVAS_COLOR)
  END IF

  XuiSendMessage(#CanvasGrid, #Redraw, 0,0,0,0,0,0)

  IF(first) THEN
    'Change console
    XstGetConsoleGrid(@grid)
    XuiSendMessage(grid, #GetColor, @a, @b, @c, @d, 1, 0)
    XuiSendMessage(grid, #SetColor, $$White, $$Green, c, d, 1,0)
    XuiSendMessage (grid, #SetStyle, 2, 0, 0, 0, 2, 0)
    XuiSendMessage (grid, #SetStyle, 2, 0, 0, 0, 3, 0)
    XuiGetGridNumber(grid, #GetGridNumber, @s1, 0,0,0,2,0)
    XuiGetGridNumber(grid, #GetGridNumber, @s2, 0,0,0,3,0)
    XuiSendMessage(s1, #SetColor, $$LightGrey, $$Black, $$Black, $$White, 0, 0)
    XuiSendMessage(s2, #SetColor, $$LightGrey, $$Black, $$Black, $$White, 0, 0)
    XuiSendMessage(grid, #Redraw,0,0,0,0,0,0)
    XgrGetGridWindow(grid, @window)
    XgrSetWindowPositionAndSize(window, 5, 25, gw, 100)
    XuiSendMessage(grid, #SetWindowTitle, 0,0,0,0,0, $$CONSOLE_TITLE$)
    IFZ(#ShowConsole) THEN XstHideConsole()
  END IF

  XgrGetGridWindow(#GeoFile, @gwin)
  XgrGetWindowPositionAndSize(gwin, @gx, @gy, @gw, @gh)

	'Move Organizer and Record windows so they arent on top of GeoFile window
  XgrGetGridWindow(#Organizer, @gwin)
  XgrGetWindowPositionAndSize(gwin, @x, @y, @w, @h)
  XgrSetWindowPositionAndSize(gwin, gx + gw - (w / 2), (gy + gh) - h, w, h)

  XgrGetGridWindow(#Record, @gwin)
  XgrGetWindowPositionAndSize(gwin, @x, @y, @w, @h)
  XgrSetWindowPositionAndSize(gwin, gx + gw - (w / 2), (gy + gh) - h, w, h)

  GetModeString(@mode$)
  XuiSendMessage ( #GeoFile, #SetTextString, 0,0,0,0,23, @mode$)

  XuiSendMessage(#GeoFile, #SetWindowTitle, 0,0,0,0,0, @$$MAIN_TITLE$)

  IF(first) THEN
    XstGetCommandLineArguments(@argc, @argv$[])
    IF(argc > 1) THEN
      Log($$LOG_DEBUG, argv$[1])
      IF(OpenProject(argv$[1])) THEN
        #SplashActive = $$FALSE
      END IF
    ELSE
      IF(#SplashActive) THEN
        CenterWindow(#XFile)
        XuiSendMessage ( #XFile, #DisplayWindow, 0, 0, 0, 0, 0, 0)
      END IF
    END IF
  END IF

  'Process all remaining messages
  XgrMessagesPending(@count)
  IF(count > 0) THEN
    XgrProcessMessages(count)
  END IF
END FUNCTION

'  #######################
'  #####  Create ()  #####
'  #######################
'
FUNCTION  Create (grid, message, v0, v1, v2, v3, r0, (r1, r1$, r1[], r1$[]))
   STATIC  designX,  designY,  designWidth,  designHeight
   STATIC  SUBADDR  sub[]
   STATIC  upperMessage
   STATIC  Create
  '
  $Create            =   0
  $xlFieldName       =   1
  $xtlFieldName      =   2
  $xlFieldType       =   3
  $xdbDataType       =   4
  $xlFieldAttributes =   5
  $xlDataAttributes  =   6
  $xlButtonParent    =   7
  $xpbSetFieldNotes  =   8
  $xpbSetDefault     =   9
  $xpbCreate         =  10
  $xpbStopCreating   =  11
  $xpbHelp           =  12
  $xlModeParent1     =  13
    $xlLength        =  1
    $xrLength        =  2
    $xlMin           =  3
    $xtlMin          =  4
    $xlMax           =  5
    $xtlMax          =  6
    $xtlLength       =  7
  $xlSummaryParent   =  14
    $xdbSummaryType  =  1
    $xdbSummaryFields = 2
    $xlOf             = 3
  $UpperKid           = 14

  '
    IFZ sub[] THEN GOSUB Initialize
    IF XuiProcessMessage (grid, message, @v0, @v1, @v2, @v3, @r0, @r1, Create) THEN RETURN
    IF (message <= upperMessage) THEN GOSUB @sub[message]
    RETURN

  SUB Callback
    message = r1
    callback = message
    IF (message <= upperMessage) THEN GOSUB @sub[message]
  END SUB

  SUB Create
    IF (v0 <= 0) THEN v0 = 0
    IF (v1 <= 0) THEN v1 = 0
    IF (v2 <= 0) THEN v2 = designWidth
    IF (v3 <= 0) THEN v3 = designHeight
    XuiCreateGrid  (@grid, Create, @v0, @v1, @v2, @v3, r0, r1, &Create())
    XuiSendMessage ( grid, #SetGridName, 0, 0, 0, 0, 0, @"Create")

    XuiLabel       (@g, #Create, 8, 8, 120, 20, r0, grid)
    XuiSendMessage ( g, #SetCallback, grid, &Create(), -1, -1, $xlFieldName, grid)
    XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xlFieldName")
    XuiSendMessage ( g, #SetAlign, $$AlignMiddleCenter, $$JustifyRight, -1, -1, 0, 0)
    XuiSendMessage ( g, #SetBorder, $$BorderNone, $$BorderNone, $$BorderNone, 0, 0, 0)
    XuiSendMessage ( g, #SetTexture, $$TextureLower1, 0, 0, 0, 0, 0)
    XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"Field Name:")

    XuiTextLine    (@g, #Create, 132, 8, 248, 20, r0, grid)
    XuiSendMessage ( g, #SetCallback, grid, &Create(), -1, -1, $xtlFieldName, grid)
    XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xtlFieldName")
    XuiSendMessage ( g, #SetColor, $$White, $$Black, $$Black, $$White, 0, 0)
    XuiSendMessage ( g, #SetBorder, $$BorderLower1, $$BorderLower1, $$BorderNone, 0, 0, 0)
    XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 1, @"XuiArea757")
    XuiSendMessage ( g, #SetColor, $$White, $$Black, $$Black, $$White, 1, 0)

    XuiLabel       (@g, #Create, 8, 32, 120, 20, r0, grid)
    XuiSendMessage ( g, #SetCallback, grid, &Create(), -1, -1, $xlFieldType, grid)
    XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xlFieldType")
    XuiSendMessage ( g, #SetAlign, $$AlignMiddleCenter, $$JustifyRight, -1, -1, 0, 0)
    XuiSendMessage ( g, #SetBorder, $$BorderNone, $$BorderNone, $$BorderNone, 0, 0, 0)
    XuiSendMessage ( g, #SetTexture, $$TextureLower1, 0, 0, 0, 0, 0)
    XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"Field Type:")

    XuiDropButton  (@g, #Create, 132, 32, 248, 20, r0, grid)
    XuiSendMessage ( g, #SetCallback, grid, &Create(), -1, -1, $xdbDataType, grid)
    XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xdbDataType")
    XuiSendMessage ( g, #SetStyle, 0, 0, 0, 0, 0, 0)
    XuiSendMessage ( g, #SetFont, 240, 1000, 0, 0, 0, @"MS Sans Serif")
    XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"- Select Field Type -")
    DIM text$[7]
    text$[0] = "Text - Single Line"
    text$[1] = "Text - Multi Line"
    text$[2] = "Integer"
    text$[3] = "Real Number"
    text$[4] = "Date"
    text$[5] = "Summary"
    text$[6] = "Image"
    XuiSendMessage ( g, #SetTextArray, 0, 0, 0, 0, 0, @text$[])
    XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 1, @"PressButton")
    XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 1, @"- Select Field Type -")
    XuiSendMessage ( g, #SetFont, 240, 1000, 0, 0,1,@"MS Sans Serif")
    XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 2, @"XuiPullDown760")
    XuiSendMessage ( g, #SetFont, 240, 1000, 0, 0, 2, @"MS Sans Serif")

    XuiLabel       (@g, #Create, 8, 56, 180, 20, r0, grid)
    XuiSendMessage ( g, #SetCallback, grid, &Create(), -1, -1, $xlFieldAttributes, grid)
    XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xlFieldAttributes")
    XuiSendMessage ( g, #SetBorder, $$BorderNone, $$BorderNone, $$BorderNone, 0, 0, 0)
    XuiSendMessage ( g, #SetTexture, $$TextureLower1, 0, 0, 0, 0, 0)
    XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"Field Attributes")

    XuiLabel       (@g, #Create, 196, 56, 184, 20, r0, grid)
    XuiSendMessage ( g, #SetCallback, grid, &Create(), -1, -1, $xlDataAttributes, grid)
    XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xlDataAttributes")
    XuiSendMessage ( g, #SetBorder, $$BorderNone, $$BorderNone, $$BorderNone, 0, 0, 0)
    XuiSendMessage ( g, #SetTexture, $$TextureLower1, 0, 0, 0, 0, 0)
    XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"Data Attributes")

    XuiLabel       (@g, #Create, 8, 76, 180, 88, r0, grid)
    XuiSendMessage ( g, #SetCallback, grid, &Create(), -1, -1, $xlButtonParent, grid)
    XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xlButtonParent")
    XuiSendMessage ( g, #SetBorder, $$BorderLoLine1, $$BorderLoLine1, $$BorderNone, 0, 0, 0)

    XuiPushButton  (@g, #Create, 16, 92, 164, 20, r0, grid)
    XuiSendMessage ( g, #SetCallback, grid, &Create(), -1, -1, $xpbSetFieldNotes, grid)
    XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xpbSetFieldNotes")
    XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"Set Field Notes")

    XuiPushButton  (@g, #Create, 16, 124, 164, 20, r0, grid)
    XuiSendMessage ( g, #SetCallback, grid, &Create(), -1, -1, $xpbSetDefault, grid)
    XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xpbSetDefault")
    XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"Set Default...")

    XuiPushButton  (@g, #Create, 8, 172, 80, 20, r0, grid)
    XuiSendMessage ( g, #SetCallback, grid, &Create(), -1, -1, $xpbCreate, grid)
    XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xpbCreate")
    XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"Create")

    XuiPushButton  (@g, #Create, 140, 172, 116, 20, r0, grid)
    XuiSendMessage ( g, #SetCallback, grid, &Create(), -1, -1, $xpbStopCreating, grid)
    XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xpbStopCreating")
    XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"Stop Creating")

    XuiPushButton  (@g, #Create, 300, 172, 80, 20, r0, grid)
    XuiSendMessage ( g, #SetCallback, grid, &Create(), -1, -1, $xpbHelp, grid)
    XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xpbHelp")
    XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"Help")

    'Mode parent
    XuiLabel       (@g0, #Create, 196, 76, 184, 88, r0, grid)
    XuiSendMessage ( g0, #SetCallback, grid, &Create(), -1, -1, $xlModeParent1, grid)
    XuiSendMessage ( g0, #SetGridName, 0, 0, 0, 0, 0, @"xlModeParent1")
    XuiSendMessage ( g0, #SetBorder, $$BorderLoLine1, $$BorderLoLine1, $$BorderNone, 0, 0, 0)

     XuiLabel       (@g, #Create, 6, 10, 76, 20, r0, g0)
     XuiSendMessage ( g, #SetCallback, grid, &Create(), $xlModeParent1, -1, $xlLength, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xlLength")
     XuiSendMessage ( g, #SetBorder, $$BorderNone, $$BorderNone, $$BorderNone, 0, 0, 0)
     XuiSendMessage ( g, #SetTexture, $$TextureLower1, 0, 0, 0, 0, 0)
     XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"Length:")
     XuiSendMessage ( g, #SetFont, 240, 1000, 0, 0, 0, @"MS Sans Serif")

     XuiRange       (@g, #Create, 132, 10, 43, 20, r0, g0)
     XuiSendMessage ( g, #SetCallback, grid, &Create(), $xlModeParent1, -1, $xrLength, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xrLength")
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 1, @"Label")
     XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 1, @"64")
     XuiSendMessage ( g, #Destroy, 0,0,0,0, 1, 0)
     XuiSendMessage ( g, #SetValues, 64, 1, 1, $$MAX_FIELD_LENGTH, 0, 0)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 2, @"Button0")
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 3, @"Button1")
     XuiSendMessage ( g, #SetFont, 240, 1000, 0, 0, 0, @"MS Sans Serif")

     XuiLabel       (@g, #Create, 10, 37, 50, 20, r0, g0)
     XuiSendMessage ( g, #SetCallback, grid, &Create(), $xlModeParent1, -1, $xlMin, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xlMin")
     XuiSendMessage ( g, #SetAlign, $$AlignMiddleCenter, $$JustifyRight, -1, -1, 0, 0)
     XuiSendMessage ( g, #SetBorder, $$BorderNone, $$BorderNone, $$BorderNone, 0, 0, 0)
     XuiSendMessage ( g, #SetTexture, $$TextureLower1, 0, 0, 0, 0, 0)
     XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"Min:")
     XuiSendMessage ( g, #SetFont, 240, 1000, 0, 0, 0, @"MS Sans Serif")

     XuiTextLine    (@g, #Create, 96, 37, 80, 20, r0, g0)
     XuiSendMessage ( g, #SetCallback, grid, &Create(), $xlModeParent1, -1, $xtlMin, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xtlMin")
     XuiSendMessage ( g, #SetColor, $$White, $$Black, $$Black, $$White, 0, 0)
     XuiSendMessage ( g, #SetBorder, $$BorderLower1, $$BorderLower1, $$BorderNone, 0, 0, 0)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 1, @"XuiArea779")
     XuiSendMessage ( g, #SetColor, $$White, $$Black, $$Black, $$White, 1, 0)
     XuiSendMessage ( g, #SetFont, 240, 1000, 0, 0, 0, @"MS Sans Serif")

     XuiLabel       (@g, #Create, 10, 60, 50, 20, r0, g0)
     XuiSendMessage ( g, #SetCallback, grid, &Create(), $xlModeParent1, -1, $xlMax, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xlMax")
     XuiSendMessage ( g, #SetAlign, $$AlignMiddleCenter, $$JustifyRight, -1, -1, 0, 0)
     XuiSendMessage ( g, #SetBorder, $$BorderNone, $$BorderNone, $$BorderNone, 0, 0, 0)
     XuiSendMessage ( g, #SetTexture, $$TextureLower1, 0, 0, 0, 0, 0)
     XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"Max:")
     XuiSendMessage ( g, #SetFont, 240, 1000, 0, 0, 0, @"MS Sans Serif")

     XuiTextLine    (@g, #Create, 96, 60, 80, 20, r0, g0)
     XuiSendMessage ( g, #SetCallback, grid, &Create(), $xlModeParent1, -1, $xtlMax, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xtlMax")
     XuiSendMessage ( g, #SetColor, $$White, $$Black, $$Black, $$White, 0, 0)
     XuiSendMessage ( g, #SetBorder, $$BorderLower1, $$BorderLower1, $$BorderNone, 0, 0, 0)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 1, @"XuiArea781")
     XuiSendMessage ( g, #SetColor, $$White, $$Black, $$Black, $$White, 1, 0)
     XuiSendMessage ( g, #SetFont, 240, 1000, 0, 0, 0, @"MS Sans Serif")

     XuiTextLine    (@g, #Create, 96, 10, 67, 20, r0, g0)
     XuiSendMessage ( g, #SetTextString, 0,0,0,0,0,@"64")
     XuiSendMessage ( g, #SetCallback, grid, &Create(), $xlModeParent1, -1, $xtlLength, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xtlLength")
     XuiSendMessage ( g, #SetColor, $$White, $$Black, $$Black, $$White, 0, 0)
     XuiSendMessage ( g, #SetBorder, $$BorderLower1, $$BorderLower1, $$BorderNone, 0, 0, 0)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 1, @"XuiArea779")
     XuiSendMessage ( g, #SetColor, $$White, $$Black, $$Black, $$White, 1, 0)
     XuiSendMessage ( g, #SetFont, 240, 1000, 0, 0, 0, @"MS Sans Serif")

    'Summary widgets
    XuiLabel       (@g1, #Create, 196, 76, 184, 88, r0, grid)
    XuiSendMessage ( g1, #SetCallback, grid, &Create(), -1, -1, $xlSummaryParent, grid)
    XuiSendMessage ( g1, #SetGridName, 0, 0, 0, 0, 0, @"XuiLabel787")
    XuiSendMessage ( g1, #SetBorder, $$BorderLoLine1, $$BorderLoLine1, $$BorderNone, 0, 0, 0)
    XuiSendMessage ( g1, #SetFont, 240, 1000, 0, 0, 0, @"MS Sans Serif")

     XuiDropBox     (@g, #Create, 10, 10, 160, 24, r0, g1)
     XuiSendMessage ( g, #SetCallback, grid, &Create(), $xlSummaryParent, -1, $xdbSummaryType, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xdbSummaryType")
     XuiSendMessage ( g, #SetStyle, 0, 0, 0, 0, 0, 0)
     XuiSendMessage ( g, #SetColor, $$White, $$Black, $$Black, $$White, 0, 0)
     XuiSendMessage ( g, #SetFont, 240, 1000, 0, 0, 0, @"MS Sans Serif")
     XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"Total")
     DIM text$[3]
     text$[0] = "Total"
     text$[1] = "Average"
     text$[2] = "Minimum"
     text$[3] = "Maximum"
     XuiSendMessage ( g, #SetTextArray, 0, 0, 0, 0, 0, @text$[])
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 1, @"TextLine")
     XuiSendMessage ( g, #SetColor, $$White, $$Black, $$Black, $$White, 1, 0)
     XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 1, @"Total")
     XuiSendMessage ( g, #SetFont, 240, 1000, 0, 0, 1, @"MS Sans Serif")
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 2, @"PressButton")
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 3, @"XuiPullDown792")
     XuiSendMessage ( g, #SetFont, 240, 1000, 0, 0, 3, @"MS Sans Serif")
     XuiSendMessage ( g, #SetColor, $$White, $$Black, $$Black, $$Green, 3, 0)
     XuiSendMessage ( g, #SetColorExtra, $$Grey, $$Green, $$Black, $$White, 3, 0)

     XuiDropBox     (@g, #Create, 10, 54, 160, 24, r0, g1)
     XuiSendMessage ( g, #SetCallback, grid, &Create(), $xlSummaryParent, -1, $xdbSummaryFields, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xdpSummaryFields")
     XuiSendMessage ( g, #SetStyle, 0, 0, 0, 0, 0, 0)
     XuiSendMessage ( g, #SetFont, 240, 1000, 0, 0, 0, @"MS Sans Serif")
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 1, @"TextLine")
     XuiSendMessage ( g, #SetFont, 240, 1000, 0, 0, 1, @"MS Sans Serif")
     XuiSendMessage ( g, #SetColor, $$White, $$Black, $$Black, $$White, 1, 0)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 2, @"PressButton")
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 3, @"XuiPullDown798")
     XuiSendMessage ( g, #SetFont, 240, 1000, 0, 0, 3, @"MS Sans Serif")
     XuiSendMessage ( g, #SetColor, $$White, $$Black, $$Black, $$Green, 3, 0)
     XuiSendMessage ( g, #SetColorExtra, $$Grey, $$Green, $$Black, $$White, 3, 0)

     XuiLabel       (@g, #Create, 80, 34, 24, 20, r0, g1)
     XuiSendMessage ( g, #SetCallback, grid, &Create(), $xlSummaryParent, -1, $xlOf, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xlOf")
     XuiSendMessage ( g, #SetBorder, $$BorderNone, $$BorderNone, $$BorderNone, 0, 0, 0)
     XuiSendMessage ( g, #SetTexture, $$TextureNone, 0, 0, 0, 0, 0)
     XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"of")
     XuiSendMessage ( g, #SetFont, 240, 1000, 0, 0, 0, @"MS Sans Serif")

     XuiSendMessage ( g1, #Disable,0,0,0,0,0,0)
    GOSUB Resize
  END SUB

  SUB CreateWindow
     IF (v0 == 0) THEN v0 = designX
     IF (v1 == 0) THEN v1 = designY
     IF (v2 <= 0) THEN v2 = designWidth
     IF (v3 <= 0) THEN v3 = designHeight
     XuiWindow (@window, #WindowCreate, v0, v1, v2, v3, r0, @r1$)
     v0 = 0 : v1 = 0 : r0 = window : ATTACH r1$ TO display$
     GOSUB Create
     r1 = 0 : ATTACH display$ TO r1$
     XuiWindow (window, #WindowRegister, grid, -1, v2, v3, @r0, @"Create")
  END SUB

  SUB GetSmallestSize
  END SUB

  SUB Redrawn
     XuiCallback (grid, #Redrawn, v0, v1, v2, v3, r0, r1)
  END SUB

  SUB Resize
  END SUB

  SUB Selection
  END SUB

  SUB Initialize
     XuiGetDefaultMessageFuncArray (@func[])
     XgrMessageNameToNumber (@"LastMessage", @upperMessage)
  '
     func[#Callback]           = &XuiCallback ()               ' disable to handle Callback messages internally
  ' func[#GetSmallestSize]    = 0                             ' enable to add internal GetSmallestSize routine
  ' func[#Resize]             = 0                             ' enable to add internal Resize routine
  '
     DIM sub[upperMessage]
  '  sub[#Callback]            = SUBADDRESS (Callback)         ' enable to handle Callback messages internally
     sub[#Create]              = SUBADDRESS (Create)           ' must be subroutine in this function
     sub[#CreateWindow]        = SUBADDRESS (CreateWindow)     ' must be subroutine in this function
  '  sub[#GetSmallestSize]     = SUBADDRESS (GetSmallestSize)  ' enable to add internal GetSmallestSize routine
     sub[#Redrawn]             = SUBADDRESS (Redrawn)          ' generate #Redrawn callback if appropriate
  '  sub[#Resize]              = SUBADDRESS (Resize)           ' enable to add internal Resize routine
     sub[#Selection]           = SUBADDRESS (Selection)        ' routes Selection callbacks to subroutine
  '
     IF sub[0] THEN PRINT "Create() : Initialize : error ::: (undefined message)"
     IF func[0] THEN PRINT "Create() : Initialize : error ::: (undefined message)"
     XuiRegisterGridType (@Create, "Create", &Create(), @func[], @sub[])

     designX = 400
     designY = 218
     designWidth = 388
     designHeight = 204

     gridType = Create
     XuiSetGridTypeProperty (gridType, @"x",                designX)
     XuiSetGridTypeProperty (gridType, @"y",                designY)
     XuiSetGridTypeProperty (gridType, @"width",            designWidth)
     XuiSetGridTypeProperty (gridType, @"height",           designHeight)
     XuiSetGridTypeProperty (gridType, @"maxWidth",         designWidth)
     XuiSetGridTypeProperty (gridType, @"maxHeight",        designHeight)
     XuiSetGridTypeProperty (gridType, @"minWidth",         designWidth)
     XuiSetGridTypeProperty (gridType, @"minHeight",        designHeight)
     XuiSetGridTypeProperty (gridType, @"can",              $$Focus OR $$Respond OR $$Callback OR $$TextSelection)
     XuiSetGridTypeProperty (gridType, @"focusKid",         $xtlFieldName)
     XuiSetGridTypeProperty (gridType, @"inputTextString",  $xtlFieldName)
     IFZ message THEN RETURN
  END SUB
END FUNCTION

'Callback for all widgets in the Create window
FUNCTION  CreateCallback (grid, message, v0, v1, v2, v3, kid, r1)
   STATIC data_type
   STATIC sum_field
   STATIC sum_type
   SHARED FIELD FieldList[]
  $Create            =   0
  '$xlFieldName       =   1
  $xtlFieldName      =   2
  '$xlFieldType       =   3
  $xdbDataType       =   4
  '$xlFieldAttributes =   5
  '$xlDataAttributes  =   6
  '$xlButtonParent    =   7
  $xpbSetFieldNotes  =   8
  $xpbSetDefault     =   9
  $xpbCreate         =  10
  $xpbStopCreating   =  11
  $xpbHelp           =  12
  $xlModeParent1     =  13
  '  $xlLength        =  1
     $xrLength        =  2
  '  $xlMin              =  3
    $xtlMin          =  4
  '  $xlMax           =  5
    $xtlMax          =  6
    $xtlLength       =  7
  $xlSummaryParent   =  14
    $xdbSummaryType  =  1
    $xdbSummaryFields = 2
  '  $xlOf             = 3
  $UpperKid           = 14

  redraw = $$FALSE

  SELECT CASE v2
    CASE $xlModeParent1   : GOSUB ModeHandler
    CASE $xlSummaryParent : GOSUB SummaryHandler
    CASE ELSE : GOSUB CreateHandler
  END SELECT

  IF(redraw) THEN XuiSendMessage(#CreateField, #Redraw, 0,0,0,0,0,0)

  RETURN


'###### Subs ######################

  '### Mode #####

  SUB ModeHandler
    XuiSendMessage(grid, #GetGridNumber, @grid, 0,0,0, $xlModeParent1,0)
    IF (message == #Callback) THEN message = r1
    SELECT CASE message
      CASE #Selection : GOSUB ModeSelection
    END SELECT
  END SUB

  SUB ModeSelection
    SELECT CASE kid
      CASE $xrLength          : GOSUB UpdateLength
      CASE $xtlLength         : GOSUB UpdateLength
    END SELECT
  END SUB


  '##### Summary #####

  SUB SummaryHandler
    XuiSendMessage(grid, #GetGridNumber, @grid, 0,0,0, $xlSummaryParent,0)
    IF (message == #Callback) THEN message = r1
      SELECT CASE message
      CASE #Selection : GOSUB SummarySelection
    END SELECT
  END SUB

  SUB SummarySelection
    SELECT CASE kid
      CASE  $xdbSummaryType   :
        GOSUB PopulateSummaryFields
        sum_type = v0
      CASE  $xdbSummaryFields :
        XuiSendMessage(grid, #GetTextArrayLine, v0,0,0,0, $xdbSummaryFields,@line$)
        IF(line$) THEN GetFieldByName(@line$, @sum_field)
    END SELECT
  END SUB

  'Verify that summary action is appropriate to field type
  SUB PopulateSummaryFields
    REDIM #Buff$[]
    FOR i = 0 TO UBOUND(FieldList[])
      SELECT CASE FieldList[i].type
        CASE $$FT_INTEGER : REDIM #Buff$[UBOUND(#Buff$[]) + 1] : #Buff$[UBOUND(#Buff$[])] = FieldList[i].name
        CASE $$FT_REAL    : REDIM #Buff$[UBOUND(#Buff$[]) + 1] : #Buff$[UBOUND(#Buff$[])] = FieldList[i].name
      END SELECT
    NEXT i
      XuiSendMessage(grid, #SetTextArray, 0,0,0,0, $xdbSummaryFields, @#Buff$[])
     REDIM #Buff$[]
  END SUB


  '#### Create ######

  SUB CreateHandler
    IF (message == #Callback) THEN
      message = r1
    END IF
    SELECT CASE message
      CASE #Selection      : GOSUB CreateSelection : redraw = $$TRUE
      CASE #Notify         : GOSUB Update
    END SELECT
  END SUB

  SUB CreateSelection
    SELECT CASE kid
      CASE $xdbDataType       : GOSUB xdbDataType_Clicked
      CASE $xpbSetFieldNotes  : GOSUB xpbSetFieldNotes_Clicked
      CASE $xpbCreate         : GOSUB xpbCreate_Clicked
      CASE $xpbStopCreating   : GOSUB xpbStopCreating_Clicked
      CASE $xpbHelp           : Help()
    END SELECT
  END SUB


  '######### More SUBS ##########

  SUB UpdateLength
    XuiSendMessage(#CreateField, #GetGridNumber, @grid, 0,0,0, $xlModeParent1, 0)
    IF(kid == $xrLength) THEN
      XuiSendMessage(grid, #SetTextString, 0,0,0,0, $xtlLength, STRING$(v0))
    ELSE
      XuiSendMessage(grid, #GetTextString, 0,0,0,0, $xtlLength, @line$)
      v0 = XLONG(line$)
      IF(v0 < 1) THEN v0 = 1
      IF(v0 > $$MAX_FIELD_LENGTH) THEN v0 = $$MAX_FIELD_LENGTH
      XuiSendMessage(grid, #SetTextString, 0,0,0,0, $xtlLength, STRING$(v0))
      XuiSendMessage(grid, #SetValue, v0, 0,0,0, $xrLength, 0)
    END IF
    XuiSendMessage(grid, #RedrawText, 0,0,0,0, $xtlLength, 0)
  END SUB

  SUB ValidateDataSize
    IF(data_size < 1) THEN
      ShowMessage("Length must be > 1")
      RETURN
    END IF

    IF(data_size > $$MAX_FIELD_LENGTH) THEN
      ShowMessage("Length must be <= " + STRING$($$MAX_FIELD_LENGTH))
      RETURN
    END IF
  END SUB

  SUB Update
    IF(kid != 0) THEN EXIT SUB
    IF(FieldList[v0].type != $$FT_SUMMARY) THEN
      XuiSendMessage(#CreateField, #GetGridNumber, @grid, 0,0,0, $xlModeParent1, 0)
      SELECT CASE FieldList[v0].type
        CASE $$FT_INTEGER :
          XuiSendMessage(grid, #SetTextString, 0,0,0,0,$xtlMin, STRING$(FieldList[v0].int_min))
          XuiSendMessage(grid, #SetTextString, 0,0,0,0,$xtlMax, STRING$(FieldList[v0].int_max))
        CASE $$FT_REAL    :
          XuiSendMessage(grid, #SetTextString, 0,0,0,0,$xtlMin, STRING$(FieldList[v0].real_min))
          XuiSendMessage(grid, #SetTextString, 0,0,0,0,$xtlMax, STRING$(FieldList[v0].real_max))
        CASE ELSE       :
          XuiSendMessage(grid, #SetTextString, 0,0,0,0,$xtlMin, STRING$(FieldList[v0].min))
          XuiSendMessage(grid, #SetTextString, 0,0,0,0,$xtlMax, STRING$(FieldList[v0].max))
      END SELECT
      XuiSendMessage(grid, #SetValue, FieldList[v0].size,0,0,0,$xrLength, 0)
      XuiSendMessage(grid, #SetTextString, 0,0,0,0,$xtlLength, STRING$(FieldList[v0].size))
      XuiSendMessage(#CreateField, #SetTextString, 0,0,0,0, $xtlFieldName, FieldList[v0].name)
    ELSE
      XuiSendMessage(#CreateField, #GetGridNumber, @grid, 0,0,0, $xlSummaryParent, 0)
      XuiSendMessage(grid, #GetTextArrayLine, FieldList[v0].min,0,0,0, $xdbSummaryType, @line$)
      XuiSendMessage(grid, #SetTextString, 0,0,0,0, $xdbSummaryType, line$)
      IF(FieldList[v0].max != -1) THEN
        GOSUB PopulateSummaryFields
        XuiSendMessage(grid, #SetTextString, 0,0,0,0, $xdbSummaryFields, FieldList[FieldList[v0].max].name)
      ELSE
        XuiSendMessage(grid, #SetTextString, 0,0,0,0, $xdbSummaryFields, 0)
      END IF
      XuiSendMessage(#CreateField, #SetTextString, 0,0,0,0, $xtlFieldName, FieldList[v0].name)
    END IF
    v0 = FieldList[v0].type
    kid = $xdbDataType
    grid = #CreateField
    GOSUB xdbDataType_Clicked
    XuiSendMessage(#CreateField, #Redraw,0,0,0,0,0,0)
  END SUB

  SUB xpbStopCreating_Clicked
    XuiSendMessage(grid, #HideWindow, 0,0,0,0,0,0)
  END SUB

  SUB xdbDataType_Clicked
    data_type = v0
    XuiSendMessage(grid, #GetTextArrayLine, v0,0,0,0, kid, @temp$)
    XuiSendMessage(grid, #SetTextString, 0,0,0,0, kid, @temp$)
    'Enable/Disable widgets as needed
    SELECT CASE v0
      CASE $$FT_STRING_SINGLE,$$FT_STRING_MULTI :
        GOSUB EnableParent
        XuiGetGridNumber(grid, #GetGridNumber, @g, 0,0,0, $xlModeParent1,0)
        XuiSendMessage(g, #Disable, 0,0,0,0,$xtlMin,0)
        XuiSendMessage(g, #Disable, 0,0,0,0,$xtlMax,0)
        XuiSendMessage(g, #Enable, 0,0,0,0,$xrLength,0)
        XuiSendMessage(g, #Enable, 0,0,0,0,$xtlLength,0)
      CASE $$FT_INTEGER,$$FT_REAL,$$FT_DATE:
        GOSUB EnableParent
        XuiGetGridNumber(grid, #GetGridNumber, @g, 0,0,0, $xlModeParent1,0)
        XuiSendMessage(g, #Enable, 0,0,0,0,$xtlMin,0)
        XuiSendMessage(g, #Enable, 0,0,0,0,$xtlMax,0)
        XuiSendMessage(g, #Disable, 0,0,0,0,$xrLength,0)
        XuiSendMessage(g, #Disable, 0,0,0,0,$xtlLength,0)
      CASE $$FT_SUMMARY:
        GOSUB EnableParent
        sum_type = -1: sum_field = -1
      CASE $$FT_IMAGE:
        GOSUB EnableParent
        XuiGetGridNumber(grid, #GetGridNumber, @g, 0,0,0, $xlModeParent1,0)
        XuiSendMessage(g, #Enable, 0,0,0,0,$xtlMin,0)
        XuiSendMessage(g, #Enable, 0,0,0,0,$xtlMax,0)
        XuiSendMessage(g, #Disable, 0,0,0,0,$xrLength,0)
        XuiSendMessage(g, #Disable, 0,0,0,0,$xtlLength,0)
    END SELECT
  END SUB

  SUB EnableParent
    SELECT CASE v0:
      CASE $$FT_SUMMARY:
        XuiSendMessage(grid, #Disable, 0,0,0,0, $xlModeParent1, 0)
        XuiSendMessage(grid, #Enable, 0,0,0,0, $xlSummaryParent, 0)
      CASE ELSE:
        XuiSendMessage(grid, #Enable, 0,0,0,0, $xlModeParent1, 0)
        XuiSendMessage(grid, #Disable, 0,0,0,0, $xlSummaryParent, 0)
    END SELECT
  END SUB

  SUB xpbSetFieldNotes_Clicked
    XuiSendMessage(#Note, #DisplayWindow, 0,0,0,0,0,0)
  END SUB

  SUB xpbCreate_Clicked
    IFZ(#CurrentProject$) THEN
      ShowMessage("No project loaded!")
      EXIT SUB
    END IF

    XuiSendMessage(grid, #GetTextString, 0,0,0,0, $xtlFieldName, @name$)

    'Verify name is useable
    IFZ(name$) THEN EXIT SUB
    IF(CheckFieldName(name$) == $$FALSE) THEN
      EXIT SUB
    END IF
    IF(LEN(name$) > $$MAX_FIELD_NAME_LENGTH) THEN
      ShowMessage("Field Name exceeds " + STR$($$MAX_FIELD_NAME_LENGTH) + " characters!")
      EXIT SUB
    END IF

    XuiGetGridNumber(grid, #GetGridNumber, @g, 0,0,0, $xlModeParent1,0)
    XuiGetGridNumber(grid, #GetGridNumber, @g1, 0,0,0, $xlSummaryParent,0)
    SELECT CASE data_type
      CASE $$FT_STRING_SINGLE, $$FT_STRING_MULTI:
        XuiSendMessage(g, #GetTextString, 0, 0,0,0, $xtlLength, @min$)
        data_size = XLONG(min$)
        GOSUB ValidateDataSize
        min$ = "0": max$ = "0"
        new = AddField(name$, data_type, data_size, $$TRUE, $$TRUE, DOUBLE(min$), DOUBLE(max$))
      CASE $$FT_INTEGER, $$FT_REAL:
        XuiSendMessage(g, #GetTextString, 0, 0,0,0, $xtlMin, @min$)
        XuiSendMessage(g, #GetTextString, 0, 0,0,0, $xtlMax, @max$)
        new = AddField(name$, data_type, $$DEFAULT_NUM_SIZE, $$TRUE, $$TRUE, DOUBLE(min$), DOUBLE(max$))
      CASE $$FT_IMAGE:
        XuiSendMessage(g, #GetTextString, 0, 0,0,0, $xtlMin, @min$)
        XuiSendMessage(g, #GetTextString, 0, 0,0,0, $xtlMax, @max$)
        IF(min$ == "" || max$ == "") THEN
          min$ = "0" : max$ = "0"
        END IF
        new = AddField(name$, data_type, $$DEFAULT_NUM_SIZE, $$TRUE, $$TRUE, DOUBLE(min$), DOUBLE(max$))
      CASE $$FT_DATE:
        min$ = "0": max$ = "0"
        new = AddField(name$, data_type, $$DEFAULT_NUM_SIZE, $$TRUE, $$TRUE, 0, 0)
      CASE $$FT_SUMMARY:
        IF(sum_type == -1 || sum_field == -1) THEN
          Log($$LOG_INFO, "No summary type or field selected!")
          ShowMessage("You must select a summary type\nand summary field!")
          EXIT SUB
        END IF
        new = AddField(name$, data_type, $$DEFAULT_NUM_SIZE, $$TRUE, $$TRUE, DOUBLE(sum_type), DOUBLE(sum_field))
    END SELECT
    GetFieldByGrid(new, @g)
    UpdateLayouts($$TRUE, g)
    GOSUB ClearEntryFields
  END SUB

  SUB ClearEntryFields
    'Clear entry fields
    XuiGetGridNumber(#CreateField, #GetGridNumber, @g, 0,0,0, $xlModeParent1,0)

    XuiSendMessage(#CreateField, #SetTextString, 0,0,0,0, $xtlFieldName, 0)
    XuiSendMessage(#CreateField, #RedrawText, 0,0,0,0, $xtlFieldName, 0)

    XuiSendMessage(g, #SetTextString, 0, 0,0,0, $xtlMin, 0)
    XuiSendMessage(g, #RedrawText, 0,0,0,0, $xtlMin, 0)
    XuiSendMessage(g, #SetTextString, 0, 0,0,0, $xtlMax, 0)
    XuiSendMessage(g, #RedrawText, 0,0,0,0, $xtlMax, 0)
    XuiSendMessage(g, #SetTextString, 0, 0,0,0, $xtlLength, STRING$($$DEFAULT_STRING_SIZE))
    XuiSendMessage(g, #SetValue, $$DEFAULT_STRING_SIZE, 0,0,0, $xrLength, 0)
    XuiSendMessage(g, #RedrawText, 0,0,0,0, $xtlLength, 0)
  END SUB
END FUNCTION

'  #####################
'  #####  Note ()  #####
'  #####################
'
FUNCTION  Note (grid, message, v0, v1, v2, v3, r0, (r1, r1$, r1[], r1$[]))
  STATIC  designX,  designY,  designWidth,  designHeight
  STATIC  SUBADDR  sub[]
  STATIC  upperMessage
  STATIC  Note
'
  $Note       =   0  ' kid   0 grid type = Note
  $xtaNote    =   1  ' kid   1 grid type = XuiTextArea
  $xpbOk      =   2  ' kid   2 grid type = XuiPushButton
  $xpbCancel  =   3  ' kid   3 grid type = XuiPushButton
  $xpbHelp    =   4  ' kid   4 grid type = XuiPushButton
  $UpperKid   =   4  ' kid maximum

  IFZ sub[] THEN GOSUB Initialize
  IF XuiProcessMessage (grid, message, @v0, @v1, @v2, @v3, @r0, @r1, Note) THEN RETURN
  IF (message <= upperMessage) THEN GOSUB @sub[message]
  RETURN

  SUB Callback
    message = r1
    callback = message
    IF (message <= upperMessage) THEN GOSUB @sub[message]
  END SUB

  SUB Create
    IF (v0 <= 0) THEN v0 = 0
    IF (v1 <= 0) THEN v1 = 0
    IF (v2 <= 0) THEN v2 = designWidth
    IF (v3 <= 0) THEN v3 = designHeight
    XuiCreateGrid  (@grid, Note, @v0, @v1, @v2, @v3, r0, r1, &Note())
    XuiSendMessage ( grid, #SetGridName, 0, 0, 0, 0, 0, @"Note")
    XuiTextArea    (@g, #Create, 4, 4, 384, 96, r0, grid)
    XuiSendMessage ( g, #SetCallback, grid, &Note(), -1, -1, $xtaNote, grid)
    XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xtaNote")
    XuiSendMessage ( g, #SetStyle, 1, 0, 0, 0, 0, 0)
    XuiSendMessage ( g, #SetColor, $$White, $$Black, $$Black, $$White, 0, 0)
    XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 1, @"Text")
    XuiSendMessage ( g, #SetColor, $$White, $$Black, $$Black, $$White, 1, 0)
    XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 2, @"ScrollH")
    XuiSendMessage ( g, #SetStyle, 1, 0, 0, 0, 2, 0)
    XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 3, @"ScrollV")
    XuiSendMessage ( g, #SetStyle, 1, 0, 0, 0, 3, 0)
    XuiPushButton  (@g, #Create, 56, 104, 80, 20, r0, grid)
    XuiSendMessage ( g, #SetCallback, grid, &Note(), -1, -1, $xpbOk, grid)
    XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xpbOk")
    XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"Ok")
    XuiPushButton  (@g, #Create, 160, 104, 80, 20, r0, grid)
    XuiSendMessage ( g, #SetCallback, grid, &Note(), -1, -1, $xpbCancel, grid)
    XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xpbCancel")
    XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"Cancel")
    XuiPushButton  (@g, #Create, 268, 104, 80, 20, r0, grid)
    XuiSendMessage ( g, #SetCallback, grid, &Note(), -1, -1, $xpbHelp, grid)
    XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xpbHelp")
    XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"Help")
    GOSUB Resize
  END SUB

  SUB CreateWindow
    IF (v0 == 0) THEN v0 = designX
    IF (v1 == 0) THEN v1 = designY
    IF (v2 <= 0) THEN v2 = designWidth
    IF (v3 <= 0) THEN v3 = designHeight
    XuiWindow (@window, #WindowCreate, v0, v1, v2, v3, r0, @r1$)
    v0 = 0 : v1 = 0 : r0 = window : ATTACH r1$ TO display$
    GOSUB Create
    r1 = 0 : ATTACH display$ TO r1$
    XuiWindow (window, #WindowRegister, grid, -1, v2, v3, @r0, @"Note")
  END SUB

  SUB GetSmallestSize
  END SUB

  SUB Redrawn
    XuiCallback (grid, #Redrawn, v0, v1, v2, v3, r0, r1)
  END SUB

  SUB Resize
  END SUB

  SUB Selection
  END SUB

  SUB Initialize
    XuiGetDefaultMessageFuncArray (@func[])
    XgrMessageNameToNumber (@"LastMessage", @upperMessage)

    func[#Callback]           = &XuiCallback ()               ' disable to handle Callback messages internally
  ' func[#GetSmallestSize]    = 0                             ' enable to add internal GetSmallestSize routine
  ' func[#Resize]             = 0                             ' enable to add internal Resize routine
  '
    DIM sub[upperMessage]
  '  sub[#Callback]            = SUBADDRESS (Callback)         ' enable to handle Callback messages internally
    sub[#Create]              = SUBADDRESS (Create)           ' must be subroutine in this function
    sub[#CreateWindow]        = SUBADDRESS (CreateWindow)     ' must be subroutine in this function
  ' sub[#GetSmallestSize]     = SUBADDRESS (GetSmallestSize)  ' enable to add internal GetSmallestSize routine
    sub[#Redrawn]             = SUBADDRESS (Redrawn)          ' generate #Redrawn callback if appropriate
  ' sub[#Resize]              = SUBADDRESS (Resize)           ' enable to add internal Resize routine
    sub[#Selection]           = SUBADDRESS (Selection)        ' routes Selection callbacks to subroutine
  '
    IF sub[0] THEN PRINT "Note() : Initialize : error ::: (undefined message)"
    IF func[0] THEN PRINT "Note() : Initialize : error ::: (undefined message)"
    XuiRegisterGridType (@Note, "Note", &Note(), @func[], @sub[])

    designX = 551
    designY = 201
    designWidth = 396
    designHeight = 132

    gridType = Note
    XuiSetGridTypeProperty (gridType, @"x",                designX)
    XuiSetGridTypeProperty (gridType, @"y",                designY)
    XuiSetGridTypeProperty (gridType, @"width",            designWidth)
    XuiSetGridTypeProperty (gridType, @"height",           designHeight)
    XuiSetGridTypeProperty (gridType, @"maxWidth",         designWidth)
    XuiSetGridTypeProperty (gridType, @"maxHeight",        designHeight)
    XuiSetGridTypeProperty (gridType, @"minWidth",         designWidth)
    XuiSetGridTypeProperty (gridType, @"minHeight",        designHeight)
    XuiSetGridTypeProperty (gridType, @"can",              $$Focus OR $$Respond OR $$Callback OR $$InputTextString)
    XuiSetGridTypeProperty (gridType, @"focusKid",         $xtaNote)
    XuiSetGridTypeProperty (gridType, @"inputTextArray",   $xtaNote)
    IFZ message THEN RETURN
  END SUB
END FUNCTION


' #########################
' #####  NoteCallback ()  #####
' #########################
'
FUNCTION  NoteCallback (grid, message, v0, v1, v2, v3, kid, r1)
'
   $Note       =   0  ' kid   0 grid type = Note
   $xtaNote    =   1  ' kid   1 grid type = XuiTextArea
   $xpbOk      =   2  ' kid   2 grid type = XuiPushButton
   $xpbCancel  =   3  ' kid   3 grid type = XuiPushButton
   $xpbHelp    =   4  ' kid   4 grid type = XuiPushButton
   $UpperKid   =   4  ' kid maximum

   IF (message == #Callback) THEN message = r1

   SELECT CASE message
      CASE #Selection      : GOSUB Selection
      CASE #CloseWindow : XuiSendMessage (grid, #HideWindow, 0, 0, 0, 0, 0, 0)
   END SELECT
   RETURN

  SUB Selection
    SELECT CASE kid
      CASE $Note       :
      CASE $xtaNote    :
      CASE $xpbOk      : GOSUB xpbOk_Clicked
      CASE $xpbCancel  : GOSUB xpbCancel_Clicked
      CASE $xpbHelp    : GOSUB xpbHelp_Clicked
    END SELECT
  END SUB

  SUB xpbOk_Clicked
    XuiSendMessage(grid, #GetTextString, 0,0,0,0, kid, @temp$)
    XuiSendMessage(grid, #HideWindow, 0,0,0,0,0,0)
  END SUB

  SUB xpbCancel_Clicked
    XuiSendMessage(grid, #HideWindow, 0,0,0,0,0,0)
  END SUB

  SUB xpbHelp_Clicked
    Help()
  END SUB
END FUNCTION

'  ########################
'  #####  GeoFile ()  #####
'  ########################
'
FUNCTION  GeoFile (grid, message, v0, v1, v2, v3, r0, (r1, r1$, r1[], r1$[]))
   STATIC  designX,  designY,  designWidth,  designHeight
   STATIC  SUBADDR  sub[]
   STATIC  upperMessage
   STATIC  GeoFile
'
   $GeoFile           =   0
   $xmDesignMenu      =   1
   $xlCanvasClip      =   2
   $xlCanvas          =   3
   $XuiScrollBarH758  =   4
   $XuiScrollBarV759  =   5
   $XuiLabel796       =   6
   $XuiLabel797       =   7
   $xrbDesign         =   8
   $xrbDataEntry      =   9
   $xbLetter         =  10
   $xbImage          =  11
   $xbBackImage      =  12
   $xrbClearMode      =  13
   $xrbSelectionMode  =  14
   $XuiPushButton768  =  15
   $XuiPushButton769  =  16
   $XuiPushButton770  =  17
   $XuiPushButton771  =  18
   $XuiPushButton772  =  19
   $xrbSingle         =  20
   $xrbMulti          =  21
   $xmDataMenu      =    22
    $xlMode            =  23
   $UpperKid          =  23
'
'
   IFZ sub[] THEN GOSUB Initialize
   IF XuiProcessMessage (grid, message, @v0, @v1, @v2, @v3, @r0, @r1, GeoFile) THEN RETURN
   IF (message <= upperMessage) THEN GOSUB @sub[message]
   RETURN

  SUB Callback
     message = r1
     callback = message
     IF (message <= upperMessage) THEN GOSUB @sub[message]
  END SUB

  SUB Create
     IF (v0 <= 0) THEN v0 = 0
     IF (v1 <= 0) THEN v1 = 0
     IF (v2 <= 0) THEN v2 = designWidth
     IF (v3 <= 0) THEN v3 = designHeight
     XuiCreateGrid  (@grid, GeoFile, @v0, @v1, @v2, @v3, r0, r1, &GeoFile())
     XuiSendMessage ( grid, #SetGridName, 0, 0, 0, 0, 0, @"XFile")

     XuiMenu        (@g, #Create, 0, 0, 652, 20, r0, grid)
     XuiSendMessage ( g, #SetCallback, grid, &GeoFile(), -1, -1, $xmDesignMenu, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xmDesignMenu")
     XuiSendMessage ( g, #SetBorder, $$BorderNone, $$BorderNone, $$BorderNone, 0, 0, 0)
     XuiSendMessage ( g, #SetFont, 240, 1000, 0, 0, 0, @"MS Sans Serif")
     DIM text$[]
     i = -1
     INC i : REDIM text$[i] :  text$[i] = "_File" + SPACE$($$MENU_SPACE)
     INC i : REDIM text$[i] :  text$[i] = $$TEAROFF$
     INC i : REDIM text$[i] :  text$[i] = "\t_New"
     INC i : REDIM text$[i] :  text$[i] = "\t_Open"
     INC i : REDIM text$[i] :  text$[i] = "\t_Save"
     INC i : REDIM text$[i] :  text$[i] = "\t_Close"
     INC i : REDIM text$[i] :  text$[i] = "\t_Quit"
     INC i : REDIM text$[i] :  text$[i] = "_Edit"+ SPACE$($$MENU_SPACE)
     INC i : REDIM text$[i] :  text$[i] = $$TEAROFF$
     INC i : REDIM text$[i] :  text$[i] = "\tAdd _Image"
     INC i : REDIM text$[i] :  text$[i] = "\tSet _Background Image"
     INC i : REDIM text$[i] :  text$[i] = "\tAdd _Text"
     INC i : REDIM text$[i] :  text$[i] = "\t_Clear Background Image"
     INC i : REDIM text$[i] :  text$[i] = "\t---------------"
     INC i : REDIM text$[i] :  text$[i] = "\tSelect _All"
     INC i : REDIM text$[i] :  text$[i] = "\t_Delete"
     INC i : REDIM text$[i] :  text$[i] = "_View"+ SPACE$($$MENU_SPACE)
     INC i : REDIM text$[i] :  text$[i] = $$TEAROFF$
     INC i : REDIM text$[i] :  text$[i] = "\t_Run Bitmap Editor"
     INC i : REDIM text$[i] :  text$[i] = "\t_Page Size"
     INC i : REDIM text$[i] :  text$[i] = "\tRecord _Count"
     INC i : REDIM text$[i] :  text$[i] = "\tSho_w Console"
     INC i : REDIM text$[i] :  text$[i] = "\t_Hide Console"
     INC i : REDIM text$[i] :  text$[i] = "_Options"+ SPACE$($$MENU_SPACE)
     INC i : REDIM text$[i] :  text$[i] = $$TEAROFF$
     INC i : REDIM text$[i] :  text$[i] = "\tRuler - _Inches"
     INC i : REDIM text$[i] :  text$[i] = "\tRuler - _Pixels"
     INC i : REDIM text$[i] :  text$[i] = "_Layout"+ SPACE$($$MENU_SPACE)
     INC i : REDIM text$[i] :  text$[i] = $$TEAROFF$
     INC i : REDIM text$[i] :  text$[i] = "\t_Create"
     INC i : REDIM text$[i] :  text$[i] = "\t_Switch"
     INC i : REDIM text$[i] :  text$[i] = "\t_Rename"
     INC i : REDIM text$[i] :  text$[i] = "\t_Save"
     INC i : REDIM text$[i] :  text$[i] = "\t_Delete"
     INC i : REDIM text$[i] :  text$[i] = "\tRe_load Current"
     INC i : REDIM text$[i] :  text$[i] = "\t---------------"
     INC i : REDIM text$[i] :  text$[i] = "\t_Arrange"
     INC i : REDIM text$[i] :  text$[i] = "\t_Bump"
     INC i : REDIM text$[i] :  text$[i] = "\t_Field Order"
     INC i : REDIM text$[i] :  text$[i] = "_Properties"+ SPACE$($$MENU_SPACE)
     INC i : REDIM text$[i] :  text$[i] = $$TEAROFF$
     INC i : REDIM text$[i] :  text$[i] = "\t_Edit Field Properties"
     INC i : REDIM text$[i] :  text$[i] = "\tEdit _xfile.cfg"

     XuiSendMessage ( g, #SetTextArray, 0, 0, 0, 0, 0, @text$[])
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 1, @"XuiPullDown755")
      XuiSendMessage ( g, #SetFont, 240, 1000, 0, 0, 1, @"MS Sans Serif")

     XuiLabel       (@g, #Create, 25, 50, 600, 450, r0, grid)
    ' XuiSendMessage ( g, #SetColor, $$LightGrey, $$Black, $$Black, $$White, 0, 0)
     XuiSendMessage ( g, #SetColor, $$Green, $$Black, $$Black, $$White, 0, 0)
     XuiSendMessage ( g, #SetCallback, grid, &GeoFile(), -1, -1, $xlCanvasClip, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xlCanvasClip")
     XuiSendMessage ( g, #SetBorder, $$BorderLoLine1, $$BorderLoLine1, $$BorderNone, 0, 0, 0)

     'XuiLabel       (@g, #Create, 24, 48, 603, 451, r0, grid)
     XuiLabel       (@g, #Create, 45, 70, 579, 429, r0, grid)
     XuiSendMessage ( g, #SetColor, $$White, $$Black, $$Black, $$White, 0, 0)
     XuiSendMessage ( g, #SetCallback, grid, &GeoFile(), -1, -1, $xlCanvas, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xlCanvas")
     XuiSendMessage ( g, #SetBorder, $$BorderLoLine1, $$BorderLoLine1, $$BorderNone, 0, 0, 0)

     XuiScrollBarH  (@g, #Create, 24, 500, 604, 12, r0, grid)
     XuiSendMessage ( g, #SetCallback, grid, &GeoFile(), -1, -1, $XuiScrollBarH758, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"XuiScrollBarH758")
     XuiSendMessage ( g, #SetStyle, 2, 0, 0, 0, 0, 0)
     XuiSendMessage ( g, #Disable,0,0,0,0,0,0)

     XuiScrollBarV  (@g, #Create, 629, 48, 12, 452, r0, grid)
     XuiSendMessage ( g, #SetCallback, grid, &GeoFile(), -1, -1, $XuiScrollBarV759, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"XuiScrollBarV759")
     XuiSendMessage ( g, #SetStyle, 2, 0, 0, 0, 0, 0)
     XuiSendMessage ( g, #Disable,0,0,0,0,0,0)

     XuiLabel       (@g, #Create, 24, 512, 164, 36, r0, grid)
     XuiSendMessage ( g, #SetCallback, grid, &GeoFile(), -1, -1, $XuiLabel796, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"XuiLabel796")
     XuiSendMessage ( g, #SetBorder, $$BorderNone, $$BorderNone, $$BorderNone, 0, 0, 0)
     XuiLabel       (@g, #Create, 464, 512, 164, 36, r0, grid)
     XuiSendMessage ( g, #SetCallback, grid, &GeoFile(), -1, -1, $XuiLabel797, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"XuiLabel797")
     XuiSendMessage ( g, #SetBorder, $$BorderNone, $$BorderNone, $$BorderNone, 0, 0, 0)

     XuiRadioButton (@g, #Create, 28, 516, 76, 28, r0, grid)
     XuiSendMessage ( g, #SetCallback, grid, &GeoFile(), -1, -1, $xrbDesign, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xrbDesign")
     'XuiSendMessage ( g, #SetBorder, $$BorderLower2, $$BorderRaise2, $$BorderLower2, 0, 0, 0)
     XuiSendMessage ( g, #SetImage, 0, 0, 0, 0, 0, "." + $$PathSlash$ + "images" + $$PathSlash$ + "design.bmp")
     XuiSendMessage ( g, #SetHintString, 0,0,0,0,0, @"Switch to Design mode")

     XuiRadioButton (@g, #Create, 104, 516, 76, 28, r0, grid)
     XuiSendMessage ( g, #SetCallback, grid, &GeoFile(), -1, -1, $xrbDataEntry, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xrbDataEntry")
      XuiSendMessage ( g, #SetImage, 0, 0, 0, 0, 0, "." + $$PathSlash$ + "images" + $$PathSlash$ + "data_entry.bmp")
     XuiSendMessage ( g, #SetHintString, 0,0,0,0,0, @"Switch to Data Entry mode")

  'Drawing Tools
     XuiPushButton  (@g, #Create, 0, 48, 20, 20, r0, grid)
     XuiSendMessage ( g, #SetCallback, grid, &GeoFile(), -1, -1, $xbLetter, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xbLetter")
     XuiSendMessage ( g, #SetImage, 0, 0, 0, 0, 0, "." + $$PathSlash$ + "images" + $$PathSlash$ + "letter.bmp")
     XuiSendMessage ( g, #SetImageCoords, 0, 0, 46, 40, 0, 0)
     XuiSendMessage ( g, #SetHintString, 0,0,0,0,0, @"Add text label")

     XuiPushButton  (@g, #Create, 0, 68, 20, 20, r0, grid)
     XuiSendMessage ( g, #SetCallback, grid, &GeoFile(), -1, -1, $xbImage, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xbImage")
     XuiSendMessage ( g, #SetImage, 0, 0, 0, 0, 0, "." + $$PathSlash$ + "images" + $$PathSlash$ + "add_img.bmp")
     XuiSendMessage ( g, #SetImageCoords, 0, 0, 46, 40, 0, 0)
     XuiSendMessage ( g, #SetHintString, 0,0,0,0,0,@"Add static image")

     XuiPushButton  (@g, #Create, 0, 88, 20, 20, r0, grid)
     XuiSendMessage ( g, #SetCallback, grid, &GeoFile(), -1, -1, $xbBackImage, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xbBackImage")
     XuiSendMessage ( g, #SetImage, 0, 0, 0, 0, 0, "." + $$PathSlash$ + "images" + $$PathSlash$ + "back_img.bmp")
     XuiSendMessage ( g, #SetImageCoords, 0, 0, 46, 40, 0, 0)
     XuiSendMessage ( g, #SetHintString, 0,0,0,0,0,@"Set background image")

     XuiRadioButton  (@g, #Create, 0, 108, 20, 20, r0, grid)
     XuiSendMessage ( g, #SetCallback, grid, &GeoFile(), -1, -1, $xrbClearMode, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xrbClear")
     XuiSendMessage ( g, #SetImage, 0, 0, 0, 0, 0, "." + $$PathSlash$ + "images" + $$PathSlash$ + "sel_clear.bmp")
     XuiSendMessage ( g, #SetImageCoords, 0, 0, 46, 40, 0, 0)
     XuiSendMessage ( g, #SetHintString, 0,0,0,0,0,@"Clear selection mode")


     XuiRadioButton  (@g, #Create, 0, 128, 20, 20, r0, grid)
     XuiSendMessage ( g, #SetCallback, grid, &GeoFile(), -1, -1, $xrbSelectionMode, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xrbSelectionMode")
     XuiSendMessage ( g, #SetImage, 0, 0, 0, 0, 0, "." + $$PathSlash$ + "images" + $$PathSlash$ + "mall.bmp")
     XuiSendMessage ( g, #SetImageCoords, 0, 0, 46, 40, 0, 0)
     XuiSendMessage ( g, #SetHintString, 0,0,0,0,0, @"Enable selection mode")

  'Tools
     XuiPushButton  (@g, #Create, 0, 24, 20, 20, r0, grid)
     XuiSendMessage ( g, #SetCallback, grid, &GeoFile(), -1, -1, $XuiPushButton768, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"XuiPushButton768")
     XuiSendMessage ( g, #SetImage, 0, 0, 0, 0, 0, "." + $$PathSlash$ + "images" + $$PathSlash$ + "icon_open.bmp")
     XuiSendMessage ( g, #SetImageCoords, 0, 0, 20, 20, 0, 0)
     XuiSendMessage ( g, #SetHintString, 0,0,0,0,0, @"Open an existing project")

     XuiPushButton  (@g, #Create, 20, 24, 20, 20, r0, grid)
     XuiSendMessage ( g, #SetCallback, grid, &GeoFile(), -1, -1, $XuiPushButton769, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"XuiPushButton769")
     XuiSendMessage ( g, #SetImage, 0, 0, 0, 0, 0, "." + $$PathSlash$ + "images" + $$PathSlash$ + "icon_new.bmp")
     XuiSendMessage ( g, #SetImageCoords, 0, 0, 46, 40, 0, 0)
     XuiSendMessage ( g, #SetHintString, 0,0,0,0,0, @"Create a new project")

     XuiPushButton  (@g, #Create, 40, 24, 20, 20, r0, grid)
     XuiSendMessage ( g, #SetCallback, grid, &GeoFile(), -1, -1, $XuiPushButton770, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"XuiPushButton770")
     XuiSendMessage ( g, #SetImage, 0, 0, 0, 0, 0, "." + $$PathSlash$ + "images" + $$PathSlash$ + "icon_save.bmp")
     XuiSendMessage ( g, #SetImageCoords, 0, 0, 46, 40, 0, 0)
     XuiSendMessage ( g, #SetHintString, 0,0,0,0,0, @"Save layout or save modified records")

     XuiPushButton  (@g, #Create, 60, 24, 20, 20, r0, grid)
     XuiSendMessage ( g, #SetCallback, grid, &GeoFile(), -1, -1, $XuiPushButton771, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"XuiPushButton771")
     XuiSendMessage ( g, #SetImage, 0, 0, 0, 0, 0, "." + $$PathSlash$ + "images" + $$PathSlash$ + "icon_saveplus.bmp")
     XuiSendMessage ( g, #SetImageCoords, 0, 0, 46, 40, 0, 0)
     XuiSendMessage ( g, #Disable,0,0,0,0,0,0)

     XuiPushButton  (@g, #Create, 80, 24, 20, 20, r0, grid)
     XuiSendMessage ( g, #SetCallback, grid, &GeoFile(), -1, -1, $XuiPushButton772, grid)
     XuiSendMessage ( g, #SetImage, 0, 0, 0, 0, 0, "." + $$PathSlash$ + "images" + $$PathSlash$ + "icon_paste.bmp")
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"XuiPushButton772")
     XuiSendMessage ( g, #Disable,0,0,0,0,0,0)

     XuiRadioButton (@g, #Create, 468, 516, 76, 28, r0, grid)
     XuiSendMessage ( g, #SetCallback, grid, &GeoFile(), -1, -1, $xrbSingle, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xrbSingle")
     XuiSendMessage ( g, #SetBorder, $$BorderLower2, $$BorderRaise2, $$BorderLower2, 0, 0, 0)
     XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"Single")
      XuiSendMessage (g, #Disable, 0,0,0,0,0,0)

     XuiRadioButton (@g, #Create, 544, 516, 76, 28, r0, grid)
    XuiSendMessage ( g, #SetCallback, grid, &GeoFile(), -1, -1, $xrbMulti, grid)
    XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xrbMulti")
    XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"Multi")
     XuiSendMessage (g, #Disable, 0,0,0,0,0,0)


    XuiMenu        (@g, #Create, 0, 0, 652, 20, r0, grid)
    XuiSendMessage ( g, #Disable, 0,0,0,0,0,0)
    XuiSendMessage ( g, #SetCallback, grid, &GeoFile(), -1, -1, $xmDataMenu, grid)
    XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xmDataMenu")
    XuiSendMessage ( g, #SetBorder, $$BorderNone, $$BorderNone, $$BorderNone, 0, 0, 0)
     XuiSendMessage ( g, #SetFont, 240, 1000, 0, 0, 0, @"MS Sans Serif")
     DIM text$[]
      i = -1
     INC i : REDIM text$[i] :  text$[i] = "_File" + SPACE$($$MENU_SPACE)
     INC i : REDIM text$[i] :  text$[i] = $$TEAROFF$
     INC i : REDIM text$[i] :  text$[i] = "\t_Import from CSV"
     INC i : REDIM text$[i] :  text$[i] = "\t_Export"
     INC i : REDIM text$[i] :  text$[i] = "\t_Quit"
     INC i : REDIM text$[i] :  text$[i] = "_Edit"+ SPACE$($$MENU_SPACE)
     INC i : REDIM text$[i] :  text$[i] = $$TEAROFF$
     INC i : REDIM text$[i] :  text$[i] = "\t_Delete All Marked"
     INC i : REDIM text$[i] :  text$[i] = "_View"+ SPACE$($$MENU_SPACE)
     INC i : REDIM text$[i] :  text$[i] = $$TEAROFF$
     INC i : REDIM text$[i] :  text$[i] = "\t_Field As List"
     INC i : REDIM text$[i] :  text$[i] = "\t_Records As HTML"
     INC i : REDIM text$[i] :  text$[i] = "\tRecord _Count"
     INC i : REDIM text$[i] :  text$[i] = "\t_Start Slide Show"
     INC i : REDIM text$[i] :  text$[i] = "\tSto_p Slide Show"
     INC i : REDIM text$[i] :  text$[i] = "\tSho_w Console"
     INC i : REDIM text$[i] :  text$[i] = "\t_Hide Console"
     INC i : REDIM text$[i] :  text$[i] = "_Insert"+ SPACE$($$MENU_SPACE)
     INC i : REDIM text$[i] :  text$[i] = $$TEAROFF$
     INC i : REDIM text$[i] :  text$[i] = "\tTodays _Date"
     INC i : REDIM text$[i] :  text$[i] = "\t_Week Of Year"
     INC i : REDIM text$[i] :  text$[i] = "\t_Current Time (12 hour)"
     INC i : REDIM text$[i] :  text$[i] = "\tCurre_nt Time (24 hour)"
     INC i : REDIM text$[i] :  text$[i] = "\tCurrent _Time (system)"
     INC i : REDIM text$[i] :  text$[i] = "_Layout"+ SPACE$($$MENU_SPACE)
     INC i : REDIM text$[i] :  text$[i] = $$TEAROFF$
     INC i : REDIM text$[i] :  text$[i] = "\t_Switch"
     INC i : REDIM text$[i] :  text$[i] = "_Mark"+ SPACE$($$MENU_SPACE)
     INC i : REDIM text$[i] :  text$[i] = $$TEAROFF$
     INC i : REDIM text$[i] :  text$[i] = "\tMark _Records"
     INC i : REDIM text$[i] :  text$[i] = "\tMark by _Formula"
     INC i : REDIM text$[i] :  text$[i] = "\t_Mark All"
     INC i : REDIM text$[i] :  text$[i] = "\t_Mark _Unsaved"
     INC i : REDIM text$[i] :  text$[i] = "\t_Unmark All"
     INC i : REDIM text$[i] :  text$[i] = "\t_Switch All Marks"
     INC i : REDIM text$[i] :  text$[i] = "\t---------------"
     INC i : REDIM text$[i] :  text$[i] = "\tShow _All"
     INC i : REDIM text$[i] :  text$[i] = "\tShow _Only Marked"
   '  INC i : REDIM text$[i] :  text$[i] = "\t---------------"
   '  INC i : REDIM text$[i] :  text$[i] = "\tMark O_ptions"
     INC i : REDIM text$[i] :  text$[i] = "_Data"+ SPACE$($$MENU_SPACE)
     INC i : REDIM text$[i] :  text$[i] = $$TEAROFF$
     INC i : REDIM text$[i] :  text$[i] = "\t_Find"
     INC i : REDIM text$[i] :  text$[i] = "\t_Sort"
   '  INC i : REDIM text$[i] :  text$[i] = "\t_Advanced Sort"
    XuiSendMessage ( g, #SetTextArray, 0, 0, 0, 0, 0, @text$[])
    XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 1, @"XuiPullDown755")
    XuiSendMessage ( g, #SetFont, 240, 1000, 0, 0, 1, @"MS Sans Serif")

    XuiLabel       (@g, #Create, 180, 520, 250, 20, r0, grid)
    XuiSendMessage ( g, #SetCallback, grid, &GeoFile(), -1, -1, $xlMode, grid)
    XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xlMode")
    XuiSendMessage ( g, #SetBorder, $$BorderNone, $$BorderNone, $$BorderNone, 0, 0, 0)
    XuiSendMessage ( g, #SetTexture, $$TextureNone, 0, 0, 0, 0, 0)
    XuiSendMessage ( g, #SetFont, 160, 400, 0, 0, 0, @"Small Fonts")
    XuiSendMessage ( g, #SetColor, $$BrightGrey, $$Blue, $$Black, $$White, 0, 0)
    GOSUB Resize
  END SUB

  SUB CreateWindow
     IF (v0 == 0) THEN v0 = designX
     IF (v1 == 0) THEN v1 = designY
     IF (v2 <= 0) THEN v2 = designWidth
     IF (v3 <= 0) THEN v3 = designHeight
     XuiWindow (@window, #WindowCreate, v0, v1, v2, v3, r0, @r1$)
     v0 = 0 : v1 = 0 : r0 = window : ATTACH r1$ TO display$
     GOSUB Create
     r1 = 0 : ATTACH display$ TO r1$
     XuiWindow (window, #WindowRegister, grid, -1, v2, v3, @r0, @"GeoFile")
  END SUB

  SUB GetSmallestSize
  END SUB

  SUB Redrawn
     XuiCallback (grid, #Redrawn, v0, v1, v2, v3, r0, r1)
  END SUB

  SUB Resize
  END SUB

  SUB Selection
  END SUB

  SUB Initialize
     XuiGetDefaultMessageFuncArray (@func[])
     XgrMessageNameToNumber (@"LastMessage", @upperMessage)
  '
     func[#Callback]           = &XuiCallback ()               ' disable to handle Callback messages internally
  ' func[#GetSmallestSize]    = 0                             ' enable to add internal GetSmallestSize routine
     func[#Resize]             = 0                            ' enable to add internal Resize routine
  '
     DIM sub[upperMessage]
  '  sub[#Callback]            = SUBADDRESS (Callback)         ' enable to handle Callback messages internally
     sub[#Create]              = SUBADDRESS (Create)           ' must be subroutine in this function
     sub[#CreateWindow]        = SUBADDRESS (CreateWindow)     ' must be subroutine in this function
     'sub[#GetSmallestSize]     = SUBADDRESS (GetSmallestSize)  ' enable to add internal GetSmallestSize routine
     sub[#Redrawn]             = SUBADDRESS (Redrawn)          ' generate #Redrawn callback if appropriate
  '   sub[#Resize]              = SUBADDRESS (Resize)           ' enable to add internal Resize routine
     sub[#Selection]           = SUBADDRESS (Selection)        ' routes Selection callbacks to subroutine
  '
     IF sub[0] THEN PRINT "GeoFile() : Initialize : error ::: (undefined message)"
     IF func[0] THEN PRINT "GeoFile() : Initialize : error ::: (undefined message)"
     XuiRegisterGridType (@GeoFile, "GeoFile", &GeoFile(), @func[], @sub[])
  '
  ' Don't remove the following 4 lines, or WindowFromFunction/WindowToFunction will not work
  '
     designX = 415
     designY = 74
     designWidth = 652
     designHeight = 552

     gridType = GeoFile
     XuiSetGridTypeProperty (gridType, @"x",                designX)
     XuiSetGridTypeProperty (gridType, @"y",                designY)
     XuiSetGridTypeProperty (gridType, @"width",            designWidth)
     XuiSetGridTypeProperty (gridType, @"height",           designHeight)
    ' XuiSetGridTypeProperty (gridType, @"maxWidth",         #displayWidth)
    ' XuiSetGridTypeProperty (gridType, @"maxHeight",        #displayHeight)
    ' XuiSetGridTypeProperty (gridType, @"minWidth",         200)
    ' XuiSetGridTypeProperty (gridType, @"minHeight",        200)
     XuiSetGridTypeProperty (gridType, @"can",              $$Focus OR $$Respond OR $$Callback)
     XuiSetGridTypeProperty (gridType, @"focusKid",         $xrbDesign)
     IFZ message THEN RETURN
  END SUB
END FUNCTION

' ############################
' #####  GeoFileCode ()  #####
' ############################
'
FUNCTION  GeoFileCode (grid, message, v0, v1, v2, v3, kid, r1)
   SHARED MODE Mode
   SHARED SEL_LIST SelList[]
   SHARED FIELD FieldList[]
   SHARED FIELD LabelList[]
   SHARED RECORD RecordList[]
   $GeoFile           =   0
   $xmDesignMenu      =   1
   $xlCanvasClip      =   2
   $xlCanvas          =   3
   $XuiScrollBarH758  =   4
   $XuiScrollBarV759  =   5
   $XuiLabel796       =   6
   $XuiLabel797       =   7
   $xrbDesign         =   8
   $xrbDataEntry      =   9
   $xbLetter         =  10
   $xbImage          =  11
   $xbBackImage      =  12
   $xrbClearMode      =  13
   $xrbSelectionMode  =  14
   $XuiPushButton768  =  15
   $XuiPushButton769  =  16
   $XuiPushButton770  =  17
   $XuiPushButton771  =  18
   $XuiPushButton772  =  19
   $xrbSingle         =  20
   $xrbMulti          =  21
   $xmDataMenu      =    22
   $xlMode            =  23
   $UpperKid          =  23

   IF(#SplashActive) THEN RETURN

   IF (message == #Callback) THEN message = r1
'
   SELECT CASE message
      CASE #Redrawn        : GOSUB Redraw
      CASE #Selected       : GOSUB Redraw
      CASE #Selection      : GOSUB Selection    ' most common callback message
      CASE #CloseWindow    : QuitProgram()
   END SELECT
   RETURN

  'Stuff to do when canvas is redrawn
  SUB Redraw
    IF(#DesignMode) THEN
      DrawRuler($$RULER_DRAW, #RulerMode)
    END IF
  END SUB

  SUB Selection
     SELECT CASE kid
        CASE $xmDesignMenu      : GOSUB DesignMenuHandler
        CASE $xmDataMenu        : GOSUB DataMenuHandler
        CASE $xlCanvas          :
        CASE $xrbDesign         : GOSUB xrbDesign_Clicked
        CASE $xrbDataEntry      : GOSUB xrbDataEntry_Clicked
        CASE $XuiPushButton768  : IF(#DesignMode) THEN GOSUB OpenProject
        CASE $XuiPushButton769  : IF(#DesignMode) THEN GOSUB CreateProject
        CASE $XuiPushButton770  : GOSUB Save
        CASE $XuiPushButton771  :
        CASE $XuiPushButton772  :
        CASE $xrbSingle         :
        CASE $xrbMulti          :
        CASE $xrbSelectionMode  : #MouseMode = $$SELECTION
        CASE $xrbClearMode      : #MouseMode = $$NONE
        CASE $xbLetter          : GOSUB AddFreeLabel
        CASE $xbImage           : IF(#DesignMode) THEN AddImage(50, 50, 0, 0, $$TRUE, @"")
        CASE $xbBackImage       : IF(#DesignMode) THEN GetFilename(@file$, @attr) : SetBackgroundImage(file$, $$TRUE)
     END SELECT
  END SUB

  SUB AddFreeLabel
    IFZ(#DesignMode) THEN EXIT SUB
    AddFreeLabel()
  END SUB

  'Main handler of Data Entry menu items
   SUB DataMenuHandler
      IF(v1 == 0) THEN
        CreateTearOff(#GeoFile, kid, v0)
        EXIT SUB
      END IF
      SELECT CASE v0
         CASE 1: GOSUB DataFileMenu
         CASE 2: GOSUB DataEditMenu
         CASE 3: GOSUB DataViewMenu
         CASE 4: GOSUB DataInsertMenu
         CASE 5: LayoutCode(#Layout, #Notify, 0,0,0,0,0,0)
                 XuiSendMessage(#Layout, #DisplayWindow, 0,0,0,0,0,0)
         CASE 6: GOSUB MarkMenu
         CASE 7: GOSUB DataMenu
      END SELECT
   END SUB

  'Main handler of Design menu itmes
   SUB DesignMenuHandler
      IF(v1 == 0) THEN
        CreateTearOff(#GeoFile, kid, v0)
        EXIT SUB
      END IF
      SELECT CASE v0
         CASE 1: GOSUB DesignFileMenu
         CASE 2: GOSUB DesignEditMenu
         CASE 3: GOSUB DesignViewMenu
         CASE 4: GOSUB DesignOptionsMenu
         CASE 5: GOSUB LayoutDesignMenu
         CASE 6: GOSUB PropertiesMenu
      END SELECT
   END SUB

  SUB DataFileMenu
    SELECT CASE v1
      CASE 1: GetFilename(@file$, @attr)
              IF(file$) THEN ImportRecords(@file$, $$IMPORT_CSV)
      CASE 2: XuiSendMessage(#Export, #DisplayWindow, 0,0,0,0,0,0)
      CASE 3: QuitProgram()
    END SELECT
  END SUB

  SUB DataEditMenu
    SELECT CASE v1
      CASE 1:
        IF(AskYesNo(@"Select 'Yes' to \ndelete marked ..")) THEN
          DeleteMarkedRecords(@v0, @v1)
          IF(v1 == $$FALSE) THEN #ShowOnlyMarked = $$FALSE
          ShowMessage("Deleted:" + STR$(v0) + " records.")
          DisplayRecord(#CurrentRecord, $$TRUE)
        END IF
    END SELECT
  END SUB

  SUB DataViewMenu
    SELECT CASE v1
      CASE 1: ListViewCode(#ListView, #Notify, $$TRUE,0,0,0,0,0) : XuiSendMessage(#ListView, #DisplayWindow, 0,0,0,0,0,0)
      CASE 2: RunExternalTool(@#HTMLViewer$)
      CASE 3: ShowMessage(STRING$(UBOUND(RecordList[]) + 1) + " records.")
      CASE 4: GOSUB StartSlideShow
      CASE 5: GOSUB StopSlideShow
      CASE 6: XstShowConsole()
      CASE 7: XstHideConsole()
    END SELECT
  END SUB

  SUB DataInsertMenu
    SELECT CASE v1
      CASE 1: GOSUB InsertDate
      CASE 2: GOSUB InsertWeek
      CASE 3,4,5: GOSUB InsertTime
    END SELECT
  END SUB

   SUB DesignFileMenu
      SELECT CASE v1
         CASE 1: GOSUB CreateProject
         CASE 2: GOSUB OpenProject
         CASE 3: GOSUB Save
         CASE 4: CloseProject($$TRUE, $$FALSE)
         CASE 5: QuitProgram()
      END SELECT
   END SUB

  SUB PropertiesMenu
    SELECT CASE v1
      CASE 1: XuiSendMessage(#FieldProperties, #DisplayWindow, 0,0,0,0,0,0)
      CASE 2: ConfigurationCode(#Configuration, #Notify, 0,0,0,0,0,0)
              XuiSendMessage(#Configuration, #DisplayWindow, 0,0,0,0,0,0)
    END SELECT
  END SUB

  SUB DesignEditMenu
    SELECT CASE v1
      CASE 1: AddImage(50, 50, 0, 0, $$TRUE, @"")
      CASE 2: GetFilename(@file$, @attr) : SetBackgroundImage(file$, $$TRUE)
      CASE 3: AddFreeLabel()
      CASE 4: SetBackgroundImage("", $$TRUE)
      CASE 6: GOSUB SelectAll : DrawSelectionRectangle(@SelList[])
      CASE 7: IF(DeleteSelectedLabels(@SelList[])) THEN
                REDIM SelList[]
                UpdateRuler($$RULER_CLEAR, $$FALSE)
                DrawRuler($$RULER_DRAW, #RulerMode)
                XuiSendMessage(#CanvasGrid, #Redraw,0,0,0,0,0,0)
              END IF
    END SELECT
  END SUB

  SUB DesignViewMenu
    SELECT CASE v1
      CASE 1:
        RunExternalTool(#BitmapEditor$)
      CASE 2:
        ModifyPageCode(#ModifyPage, #Notify,0,0,0,0,0,0)
        XuiSendMessage(#ModifyPage, #DisplayWindow, 0,0,0,0,0,0)
      CASE 3:
        ShowMessage(STRING$(UBOUND(RecordList[])) + " records.")
      CASE 4: XstShowConsole()
      CASE 5: XstHideConsole()
    END SELECT
  END SUB

   SUB DesignOptionsMenu
		 SELECT CASE v1
       CASE 1:
        #RulerMode = $$RULER_MODE_INCHES
        UpdateRuler($$RULER_CLEAR, $$FALSE)
        DrawRuler($$RULER_DRAW, #RulerMode)
       CASE 2:
        #RulerMode = $$RULER_MODE_PX
        UpdateRuler($$RULER_CLEAR, $$FALSE)
        DrawRuler($$RULER_DRAW, #RulerMode)
     END SELECT
       IF(#SelectedGrid > 0) THEN UpdateRuler($$RULER_DRAW_BOX, $$FALSE)
   END SUB

   SUB LayoutDesignMenu
      SELECT CASE v1
         CASE 1: CreateLayout()
         CASE 2: LayoutCode(#Layout, #Notify, 0,0,0,0,0,0) : XuiSendMessage(#Layout, #DisplayWindow, 0,0,0,0,0,0)
         CASE 4: SaveLayout(#CurrentLayout$)
         CASE 6: ClearCanvas()
                 LoadLayout(#CurrentLayout$, $$FALSE, $$TRUE)
                 DisplayRecord(#CurrentRecord, $$TRUE)
         CASE 8: XuiSendMessage(#Arrange, #DisplayWindow,0,0,0,0,0,0)
         CASE 9: XuiSendMessage(#Bump, #DisplayWindow,0,0,0,0,0,0)
         CASE 10: FieldOrderCode(#FieldOrder, #Notify,0,0,0,0,0,0)
                  XuiSendMessage(#FieldOrder, #DisplayWindow, 0,0,0,0,0,0)
      END SELECT
   END SUB

   '#### Mark #####
   SUB MarkMenu
      #UpdateSummaryFields = $$TRUE
      SELECT CASE v1
         CASE 1: XuiSendMessage(#MarkRecords, #DisplayWindow, 0,0,0,0,0,0)
         CASE 2: ExpressionBuilderCode(#ExpressionBuilder, #Notify,0,0,0,0,0,0)
                 XuiSendMessage(#ExpressionBuilder, #DisplayWindow, 0,0,0,0,0,0)
         CASE 3: MarkAllRecords($$MARK, $$TRUE) : DisplayRecord(#CurrentRecord, $$TRUE)
         CASE 4: GOSUB MarkDirtyRecords : DisplayRecord(#CurrentRecord, $$TRUE)
         CASE 5: MarkAllRecords($$MARK, $$FALSE) : #ShowOnlyMarked = $$FALSE : GOSUB UpdateShow
         CASE 6: MarkAllRecords($$SWITCH, 0) : DisplayRecord(#CurrentRecord, $$TRUE)
         CASE 8,9 : GOSUB UpdateShow
      END SELECT
   END SUB

  SUB MarkDirtyRecords
    IF(Mode.markMode == $$MARK_REPLACE) THEN
      MarkAllRecords($$MARK, $$FALSE)
    END IF
    GetDirtyRecords(@Buff[])
    FOR i = 0 TO UBOUND(Buff[])
      MarkRecord(Buff[i], $$TRUE)
      IF(Buff[i] == #CurrentRecord) THEN
        DisplayRecord(#CurrentRecord, $$TRUE)
      END IF
    NEXT i
    IF(#ShowOnlyMarked) THEN
      record = GetFirstRecord(GetOrderIndex(#CurrentRecord), $$GET_MARKED)
      IF(record != -1) THEN
        DisplayRecord(record, $$TRUE)
      END IF
    END IF
  END SUB

   SUB DataMenu
      SELECT CASE v1
         CASE 1: GOSUB FindData
         CASE 2: GOSUB SortData
      END SELECT
   END SUB

  SUB OpenProject
    GetFilename(@file$, @attr)
    IF(file$) THEN
      OpenProject(file$)
    END IF
  END SUB

  SUB CreateProject
     CreateProject()
  END SUB

  SUB xrbDesign_Clicked
    IF(v0 == 0) THEN EXIT SUB
    IF(#SlideShow) THEN
      GOSUB StopSlideShow
    END IF
    #DesignMode = $$TRUE
    XuiSendMessage (#CanvasGridClip, #SetColor, $$RULER_COLOR, $$Black, $$Black, $$White, 0, 0)
    CloseAllTearoffs()
    ClearFields()
    DisplayRecord(#CurrentRecord, $$TRUE)
    XuiSendMessage(#Organizer, #DisplayWindow, 0,0,0,0,0,0)
    XuiSendMessage(#Record, #HideWindow, 0,0,0,0,0,0)
    XuiSendMessage(#Find, #HideWindow,0,0,0,0,0,0)
    XuiSendMessage(#MarkRecords, #HideWindow, 0,0,0,0,0,0)
    XuiSendMessage(#ExpressionBuilder, #HideWindow,0,0,0,0,0,0)
    XuiSendMessage(#Export, #HideWindow,0,0,0,0,0,0)
    XuiSendMessage(#ListView, #HideWindow,0,0,0,0,0,0)
    XuiSendMessage(grid, #Enable, 0,0,0,0, $xmDesignMenu, 0)
    XuiSendMessage(grid, #Disable, 0,0,0,0, $xmDataMenu, 0)
    XuiSendMessage(grid, #Redraw, 0,0,0,0,$xmDesignMenu,0)

    XuiSendMessage (#CanvasGridClip, #SetBorder, $$BorderLoLine1, $$BorderLoLine1, $$BorderNone, 0, 0, 0)
    XuiSendMessage(#CanvasGridClip, #Redraw,0,0,0,0,0,0)
    XuiSendMessage(#CanvasGrid, #Redraw,0,0,0,0,0,0)
    XuiSendMessage(#GeoFileWin, #WindowSelect,0,0,0,0,0,0)
  END SUB

  SUB xrbDataEntry_Clicked
    IF(v0 == 0) THEN EXIT SUB
    #DesignMode = $$FALSE
    XuiSendMessage (#CanvasGridClip, #SetColor, $$LightGrey, $$Black, $$Black, $$White, 0, 0)
    UpdateRuler($$RULER_CLEAR, $$FALSE)
    CloseAllTearoffs()
    ClearFields()
    XuiSendMessage(#Organizer, #HideWindow, 0,0,0,0,0,0)

    DisplayRecord(#CurrentRecord, $$TRUE)
    XuiSendMessage(#Record, #SetValue, #CurrentRecord,0,0,0,7,0)
    XuiSendMessage(#Record, #Redraw, 0,0,0,0,7,0)
    XuiSendMessage(#Record, #SetTextString, #CurrentRecord,0,0,0,7,STR$(#CurrentRecord))
    XuiSendMessage(#Record, #DisplayWindow, 0,0,0,0,0,0)

    XuiSendMessage(#CreateField, #HideWindow,0,0,0,0,0,0)
    XuiSendMessage(#Note, #HideWindow,0,0,0,0,0,0)
    XuiSendMessage(#FieldOrder, #HideWindow,0,0,0,0,0,0)

    XuiSendMessage(grid, #Disable, 0,0,0,0, $xmDesignMenu, 0)
    XuiSendMessage(grid, #Enable, 0,0,0,0, $xmDataMenu, 0)
    XuiSendMessage(grid, #Redraw, 0,0,0,0,$xmDataMenu,0)

    XuiSendMessage (#CanvasGridClip, #SetBorder, $$BorderNone, $$BorderNone, $$BorderNone, 0, 0, 0)
    XuiSendMessage(#CanvasGridClip, #Redraw,0,0,0,0,0,0)
    XuiSendMessage(#CanvasGrid, #Redraw,0,0,0,0,0,0)
    XuiSendMessage(#GeoFileWin, #WindowSelect,0,0,0,0,0,0)
  END SUB

   SUB FindData
      XuiSendMessage(#Find, #DisplayWindow, 0,0,0,0,0,0)
   END SUB

   SUB SortData
     SortCode(#Sort, #Notify, 0,0,0,0,0,0)
     XuiSendMessage(#Sort, #DisplayWindow, 0,0,0,0,0,0)
   END SUB

   SUB UpdateShow
     SELECT CASE v1
       CASE 8 : #ShowOnlyMarked = $$FALSE
       CASE 9 : #ShowOnlyMarked = $$TRUE
     END SELECT

     ListViewCode(#ListView, #Notify, $$FALSE,0,0,0,0,0)
     IF(#ShowOnlyMarked) THEN
       record = GetFirstRecord(GetOrderIndex(record), $$GET_MARKED)
       UpdateShowMarked(record)
     ELSE
       Mode.viewMode = $$VIEW_ALL
       DisplayRecord(#CurrentRecord, $$TRUE)
     END IF
     GetModeString(@mode$)
     XuiSendMessage(grid, #SetTextString, 0,0,0,0, $xlMode, @mode$)
     XuiSendMessage(grid, #Redraw, 0,0,0,0, $xlMode, @mode$)
   END SUB

  SUB Save
    SaveData()
  END SUB

  SUB StartSlideShow
    Log($$LOG_INFO, "Starting Slide Show")
    #SlideShow = $$TRUE
    IF(#SlideShowTimer != 0) THEN
      XstKillTimer(#SlideShowTimer)
      #SlideShowTimer = 0
    END IF
    XstStartTimer(@#SlideShowTimer, 1, #SlideShowDelay, &SlideShow())
  END SUB

  SUB StopSlideShow
    Log($$LOG_INFO, "Stopping Slide Show")
    XstKillTimer(#SlideShowTimer)
    #SlideShowTimer = 0
    #SlideShow = $$FALSE
  END SUB

  SUB SelectAll
    REDIM SelList[]
    FOR i = 0 TO UBOUND(FieldList[])
      IF(FieldList[i].in_layout && FieldList[i].visible) THEN
        FieldList[i].selected = $$TRUE
        REDIM SelList[UBOUND(SelList[]) + 1]
        SelList[UBOUND(SelList[])].index = i
        SelList[UBOUND(SelList[])].type = $$ENTRY
        SelList[UBOUND(SelList[])].grid = FieldList[i].grid
      END IF
    NEXT i

    FOR i = 0 TO UBOUND(LabelList[])
      IF(LabelList[i].in_layout && LabelList[i].visible) THEN
        LabelList[i].selected = $$TRUE
        REDIM SelList[UBOUND(SelList[]) + 1]
        SelList[UBOUND(SelList[])].index = i
        SelList[UBOUND(SelList[])].type = $$LABEL
        SelList[UBOUND(SelList[])].grid = LabelList[i].grid
      END IF
    NEXT i

    IF(SelList[] && #SelectedGrid == 0) THEN
      #SelectedGrid = SelList[0].grid
    END IF
  END SUB

  SUB InsertDate
    InsertDate()
  END SUB

  SUB InsertWeek
    XuiSendMessage(#GeoFile, #GetKeyboardFocusGrid, @grid, 0,0,0,0,0)
    IF(GetFieldByGrid(grid, @index)) THEN
      XstGetLocalDateAndTime(@v0, @v1, @v2, 0, 0, 0, 0, 0)
      v0 = GetWeekOfYear(v0, v1, v2)
      date$ = STRING$(v0)
      XuiSendMessage(grid, #GetTextString, 0,0,0,0,0, @file$)
      IF(file$) THEN
        file$ = file$ + " " + date$
      ELSE
        file$ = date$
      END IF
      XuiSendMessage(grid, #SetTextString, 0,0,0,0,0, @file$)
      XuiSendMessage(grid, #RedrawText,0,0,0,0,0,0)
    END IF
  END SUB

  SUB InsertTime
    XuiSendMessage(#GeoFile, #GetKeyboardFocusGrid, @grid, 0,0,0,0,0)
    IF(GetFieldByGrid(grid, @index)) THEN
      SELECT CASE v1
        '12 hour
        CASE 3:
          XstGetLocalDateAndTime(0, 0, 0, 0, @hour, @minute, 0,0)
          IF(minute < 10) THEN
            minute$ = "0" + STRING$(minute)
          ELSE
            minute$ = STRING$(minute)
          END IF
          IF(hour > 12) THEN
            hour = hour - 12
            date$ = STRING$(hour) + ":" + minute$ + " PM"
          ELSE
            IF(hour == 0) THEN hour = 12
            date$ = STRING$(hour) + ":" + minute$ + " AM"
          END IF
        '24 hour
        CASE 4:
          XstGetLocalDateAndTime(0, 0, 0, 0, @hour, @minute, 0,0)
          IF(minute < 10) THEN
            minute$ = "0" + STRING$(minute)
          ELSE
            minute$ = STRING$(minute)
          END IF
          IF(hour < 10) THEN
            hour$ = "0" + STRING$(hour)
          ELSE
            hour$ = STRING$(hour)
          END IF
          date$ = hour$ + ":" + minute$
        'UNIX
        CASE 5:
          XstGetDateAndTime(@v0, @v1, @v2, @v3, @hour, @minute, @second, 0 )
          XstDateAndTimeToFileTime(v0, v1, v2, v3, hour, minute, second, 0, @time$$)
          date$ = STRING$(time$$ / 10000000)
      END SELECT

      XuiSendMessage(grid, #GetTextString, 0,0,0,0,0, @file$)
      IF(file$) THEN
        file$ = file$ + " " + date$
      ELSE
        file$ = date$
      END IF
      XuiSendMessage(grid, #SetTextString, 0,0,0,0,0, @file$)
      XuiSendMessage(grid, #RedrawText,0,0,0,0,0,0)
    END IF
  END SUB
END FUNCTION

'  ##########################
'  #####  Organizer ()  #####
'  ##########################
'
FUNCTION  Organizer (grid, message, v0, v1, v2, v3, r0, (r1, r1$, r1[], r1$[]))
   STATIC  designX,  designY,  designWidth,  designHeight
   STATIC  SUBADDR  sub[]
   STATIC  upperMessage
   STATIC  Organizer
   $Organizer            =   0  ' kid   0 grid type = Organizer
   $xlFieldsInLayout     =   1  ' kid   1 grid type = XuiList
   $xlFieldNotInLayout   =   2  ' kid   2 grid type = XuiList
   $XuiLabel782          =   3  ' kid   3 grid type = XuiLabel
   $xlNotes              =   4  ' kid   4 grid type = XuiLabel
   $xpbCreateNewField    =   5  ' kid   5 grid type = XuiPushButton
   $xpbEditThisField     =   6  ' kid   6 grid type = XuiPushButton
   $xpbDeleteThisField   =   7  ' kid   7 grid type = XuiPushButton
   $xpbAddToLayout       =   8  ' kid   8 grid type = XuiPushButton
   $xpbRemoveFromLayout  =   9  ' kid   9 grid type = XuiPushButton
   $XuiLabel769          =  10  ' kid  10 grid type = XuiLabel
   $XuiLabel770          =  11  ' kid  11 grid type = XuiLabel
   $XuiLabel789          =  12  ' kid  12 grid type = XuiLabel
   $xlSelectedField      =  13  ' kid  13 grid type = XuiLabel
   $UpperKid             =  13  ' kid maximum

   IFZ sub[] THEN GOSUB Initialize
   IF XuiProcessMessage (grid, message, @v0, @v1, @v2, @v3, @r0, @r1, Organizer) THEN RETURN
   IF (message <= upperMessage) THEN GOSUB @sub[message]
   RETURN

  SUB Callback
     message = r1
     callback = message
     IF (message <= upperMessage) THEN GOSUB @sub[message]
  END SUB

  SUB Create
     IF (v0 <= 0) THEN v0 = 0
     IF (v1 <= 0) THEN v1 = 0
     IF (v2 <= 0) THEN v2 = designWidth
     IF (v3 <= 0) THEN v3 = designHeight
     XuiCreateGrid  (@grid, Organizer, @v0, @v1, @v2, @v3, r0, r1, &Organizer())
     XuiSendMessage ( grid, #SetGridName, 0, 0, 0, 0, 0, @"Organizer")

     XuiList        (@g, #Create, 12, 28, 192, 88, r0, grid)
     XuiSendMessage ( g, #SetCallback, grid, &Organizer(), -1, -1, $xlFieldsInLayout, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xlFieldsInLayout")
     XuiSendMessage ( g, #SetBorder, $$BorderLower1, $$BorderLower1, $$BorderNone, 0, 0, 0)
     XuiSendMessage ( g, #SetStyle, 0, 0, 0, 0, 0, 0)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 1, @"List")
     XuiSendMessage ( g, #SetColor, $$White, $$Black, $$Black, $$White, 1, 0)
     XuiSendMessage ( g, #SetColorExtra, $$Grey, $$BrightGreen, $$Black, $$White, 1, 0)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 2, @"ScrollH")
     XuiSendMessage ( g, #SetStyle, 2, 0, 0, 0, 2, 0)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 3, @"ScrollV")
     XuiSendMessage ( g, #SetStyle, 2, 0, 0, 0, 3, 0)

     XuiList        (@g, #Create, 276, 28, 184, 88, r0, grid)
     XuiSendMessage ( g, #SetCallback, grid, &Organizer(), -1, -1, $xlFieldNotInLayout, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xlFieldNotInLayout")
     XuiSendMessage ( g, #SetBorder, $$BorderLower1, $$BorderLower1, $$BorderNone, 0, 0, 0)
     XuiSendMessage ( g, #SetStyle, 0, 0, 0, 0, 0, 0)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 1, @"List")
     XuiSendMessage ( g, #SetColor, $$White, $$Black, $$Black, $$White, 1, 0)
     XuiSendMessage ( g, #SetColorExtra, $$Grey, $$BrightGreen, $$Black, $$White, 1, 0)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 2, @"ScrollH")
     XuiSendMessage ( g, #SetStyle, 2, 0, 0, 0, 2, 0)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 3, @"ScrollV")
     XuiSendMessage ( g, #SetStyle, 2, 0, 0, 0, 3, 0)

     XuiLabel       (@g, #Create, 16, 156, 128, 24, r0, grid)
     XuiSendMessage ( g, #SetCallback, grid, &Organizer(), -1, -1, $XuiLabel782, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"XuiLabel782")
     XuiSendMessage ( g, #SetBorder, $$BorderNone, $$BorderNone, $$BorderNone, 0, 0, 0)
     XuiSendMessage ( g, #SetTexture, $$TextureNone, 0, 0, 0, 0, 0)
     XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"Notes:")

     XuiLabel       (@g, #Create, 148, 156, 312, 24, r0, grid)
     XuiSendMessage ( g, #SetCallback, grid, &Organizer(), -1, -1, $xlNotes, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xlNotes")
     XuiSendMessage ( g, #SetBorder, $$BorderLoLine1, $$BorderLoLine1, $$BorderNone, 0, 0, 0)

     XuiPushButton  (@g, #Create, 12, 192, 144, 20, r0, grid)
     XuiSendMessage ( g, #SetCallback, grid, &Organizer(), -1, -1, $xpbCreateNewField, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xpbCreateNewField")
     XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"Create New Fields")

     XuiPushButton  (@g, #Create, 164, 192, 144, 20, r0, grid)
     XuiSendMessage ( g, #SetCallback, grid, &Organizer(), -1, -1, $xpbEditThisField, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xpbEditThisField")
     XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"View This Field")

     XuiPushButton  (@g, #Create, 316, 192, 144, 20, r0, grid)
     XuiSendMessage ( g, #SetCallback, grid, &Organizer(), -1, -1, $xpbDeleteThisField, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xpbDeleteThisField")
     XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"Delete This Field")
  '
     XuiPushButton  (@g, #Create, 212, 28, 52, 44, r0, grid)
     XuiSendMessage ( g, #SetCallback, grid, &Organizer(), -1, -1, $xpbAddToLayout, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xpbAddToLayout")
     XuiSendMessage ( g, #SetImage, 0, 0, 0, 0, 0, "." + $$PathSlash$ + "images" + $$PathSlash$ + "arrow_l_l.bmp")
     XuiSendMessage ( g, #SetImageCoords, 0, 0, 46, 40, 0, 0)
  '
     XuiPushButton  (@g, #Create, 212, 72, 52, 44, r0, grid)
     XuiSendMessage ( g, #SetCallback, grid, &Organizer(), -1, -1, $xpbRemoveFromLayout, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xpbRemoveFromLayout")
     XuiSendMessage ( g, #SetImage, 0, 0, 0, 0, 0, "." + $$PathSlash$ + "images" + $$PathSlash$ + "arrow_r_l.bmp")
     XuiSendMessage ( g, #SetImageCoords, 0, 0, 46, 40, 0, 0)
  '
     XuiLabel       (@g, #Create, 12, 4, 188, 20, r0, grid)
     XuiSendMessage ( g, #SetCallback, grid, &Organizer(), -1, -1, $XuiLabel769, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"XuiLabel769")
     XuiSendMessage ( g, #SetBorder, $$BorderNone, $$BorderNone, $$BorderNone, 0, 0, 0)
     XuiSendMessage ( g, #SetTexture, $$TextureNone, 0, 0, 0, 0, 0)
     XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"Fields In Layout")

     XuiLabel       (@g, #Create, 276, 4, 188, 20, r0, grid)
     XuiSendMessage ( g, #SetCallback, grid, &Organizer(), -1, -1, $XuiLabel770, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"XuiLabel770")
     XuiSendMessage ( g, #SetBorder, $$BorderNone, $$BorderNone, $$BorderNone, 0, 0, 0)
     XuiSendMessage ( g, #SetTexture, $$TextureNone, 0, 0, 0, 0, 0)
     XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"Fields Not In Layout")

     XuiLabel       (@g, #Create, 16, 124, 128, 24, r0, grid)
     XuiSendMessage ( g, #SetCallback, grid, &Organizer(), -1, -1, $XuiLabel789, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"XuiLabel789")
     XuiSendMessage ( g, #SetBorder, $$BorderNone, $$BorderNone, $$BorderNone, 0, 0, 0)
     XuiSendMessage ( g, #SetTexture, $$TextureNone, 0, 0, 0, 0, 0)
     XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"Selected Field:")

     XuiLabel       (@g, #Create, 148, 124, 312, 24, r0, grid)
     XuiSendMessage ( g, #SetCallback, grid, &Organizer(), -1, -1, $xlSelectedField, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xlSelectedField")
     XuiSendMessage ( g, #SetBorder, $$BorderLoLine1, $$BorderLoLine1, $$BorderNone, 0, 0, 0)
     GOSUB Resize
  END SUB

  SUB CreateWindow
     IF (v0 == 0) THEN v0 = designX
     IF (v1 == 0) THEN v1 = designY
     IF (v2 <= 0) THEN v2 = designWidth
     IF (v3 <= 0) THEN v3 = designHeight
     XuiWindow (@window, #WindowCreate, v0, v1, v2, v3, r0, @r1$)
     v0 = 0 : v1 = 0 : r0 = window : ATTACH r1$ TO display$
     GOSUB Create
     r1 = 0 : ATTACH display$ TO r1$
     XuiWindow (window, #WindowRegister, grid, -1, v2, v3, @r0, @"Organizer")
  END SUB

  SUB GetSmallestSize
  END SUB

  SUB Redrawn
     XuiCallback (grid, #Redrawn, v0, v1, v2, v3, r0, r1)
  END SUB

  SUB Resize
  END SUB

  SUB Selection
  END SUB

  SUB Initialize
     XuiGetDefaultMessageFuncArray (@func[])
     XgrMessageNameToNumber (@"LastMessage", @upperMessage)
  '
     func[#Callback]           = &XuiCallback ()               ' disable to handle Callback messages internally
  ' func[#GetSmallestSize]    = 0                             ' enable to add internal GetSmallestSize routine
  ' func[#Resize]             = 0                             ' enable to add internal Resize routine
  '
     DIM sub[upperMessage]
  '  sub[#Callback]            = SUBADDRESS (Callback)         ' enable to handle Callback messages internally
     sub[#Create]              = SUBADDRESS (Create)           ' must be subroutine in this function
     sub[#CreateWindow]        = SUBADDRESS (CreateWindow)     ' must be subroutine in this function
  '  sub[#GetSmallestSize]     = SUBADDRESS (GetSmallestSize)  ' enable to add internal GetSmallestSize routine
     sub[#Redrawn]             = SUBADDRESS (Redrawn)          ' generate #Redrawn callback if appropriate
  '  sub[#Resize]              = SUBADDRESS (Resize)           ' enable to add internal Resize routine
     sub[#Selection]           = SUBADDRESS (Selection)        ' routes Selection callbacks to subroutine
  '
     IF sub[0] THEN PRINT "Organizer() : Initialize : error ::: (undefined message)"
     IF func[0] THEN PRINT "Organizer() : Initialize : error ::: (undefined message)"
     XuiRegisterGridType (@Organizer, "Organizer", &Organizer(), @func[], @sub[])
  '
  ' Don't remove the following 4 lines, or WindowFromFunction/WindowToFunction will not work
  '
     designX = 459
     designY = 127
     designWidth = 472
     designHeight = 220
  '
     gridType = Organizer
     XuiSetGridTypeProperty (gridType, @"x",                designX)
     XuiSetGridTypeProperty (gridType, @"y",                designY)
     XuiSetGridTypeProperty (gridType, @"width",            designWidth)
     XuiSetGridTypeProperty (gridType, @"height",           designHeight)
     XuiSetGridTypeProperty (gridType, @"maxWidth",         designWidth)
     XuiSetGridTypeProperty (gridType, @"maxHeight",        designHeight)
     XuiSetGridTypeProperty (gridType, @"minWidth",         designWidth)
     XuiSetGridTypeProperty (gridType, @"minHeight",        designHeight)
     XuiSetGridTypeProperty (gridType, @"can",              $$Focus OR $$Respond OR $$Callback)
     XuiSetGridTypeProperty (gridType, @"focusKid",         $xlFieldsInLayout)
     IFZ message THEN RETURN
  END SUB
END FUNCTION

' ##############################
' #####  OrganizerCode ()  #####
' ##############################
'
'
FUNCTION  OrganizerCode (grid, message, v0, v1, v2, v3, kid, r1)
   STATIC XLONG selected_item
   SHARED FIELD FieldList[]
   SHARED FIELD LabelList[]
   STRING in_layout$[]
   STRING out_layout$[]
   $Organizer            =   0  ' kid   0 grid type = Organizer
   $xlFieldsInLayout     =   1  ' kid   1 grid type = XuiList
   $xlFieldNotInLayout   =   2  ' kid   2 grid type = XuiList
   $XuiLabel782          =   3  ' kid   3 grid type = XuiLabel
   $xlNotes              =   4  ' kid   4 grid type = XuiLabel
   $xpbCreateNewField    =   5  ' kid   5 grid type = XuiPushButton
   $xpbEditThisField     =   6  ' kid   6 grid type = XuiPushButton
   $xpbDeleteThisField   =   7  ' kid   7 grid type = XuiPushButton
   $xpbAddToLayout       =   8  ' kid   8 grid type = XuiPushButton
   $xpbRemoveFromLayout  =   9  ' kid   9 grid type = XuiPushButton
   $XuiLabel769          =  10  ' kid  10 grid type = XuiLabel
   $XuiLabel770          =  11  ' kid  11 grid type = XuiLabel
   $XuiLabel789          =  12  ' kid  12 grid type = XuiLabel
   $xlSelectedField      =  13  ' kid  13 grid type = XuiLabel
   $UpperKid             =  13  ' kid maximum

   IF (message == #Callback) THEN message = r1
'
   SELECT CASE message
      CASE #Notify         : GOSUB Update
      CASE #Selection      : GOSUB Selection
      CASE #CloseWindow : XuiSendMessage (grid, #HideWindow, 0, 0, 0, 0, 0, 0)
   END SELECT
   RETURN

  'Update fields
  SUB Update
     GetFields($$FIELDS_IN_LAYOUT, @#Buff[])
    REDIM in$[]
    FOR i = 0 TO UBOUND(#Buff[])
      REDIM in$[i] : in$[i] = FieldList[#Buff[i]].name
    NEXT i
    REDIM out$[]
    GetFields($$FIELDS_NOT_IN_LAYOUT, @#Buff[])
    FOR i = 0 TO UBOUND(#Buff[])
      REDIM out$[i] : out$[i] = FieldList[#Buff[i]].name
    NEXT i
    XuiSendMessage(#Organizer, #SetTextArray, 0,0,0,0, $xlFieldsInLayout, @in$[])
    XuiSendMessage(#Organizer, #SetTextArray, 0,0,0,0, $xlFieldNotInLayout, @out$[])
    XuiSendMessage(#Organizer, #RedrawText, 0,0,0,0, $xlFieldsInLayout, 0)
    XuiSendMessage(#Organizer, #RedrawText, 0,0,0,0, $xlFieldNotInLayout, 0)
    XuiSendMessage(#Organizer, #SetTextString, 0,0,0,0, $xlSelectedField, @"")
    XuiSendMessage(#Organizer, #Redraw, 0,0,0,0,$xlSelectedField,0)
    selected_field = 0
  END SUB

  SUB Selection
     SELECT CASE kid
        CASE $xlFieldsInLayout     : GOSUB ChangeSelection
        CASE $xlFieldNotInLayout   : GOSUB ChangeSelection
        CASE $xpbCreateNewField    :GOSUB xpbCreateNewFields_Clicked
        CASE $xpbEditThisField     :GOSUB xpbEditThisField_Clicked
        CASE $xpbDeleteThisField   :GOSUB xpbDeleteField_Clicked
        CASE $xpbAddToLayout       :GOSUB xpbAddToLayout_Clicked
        CASE $xpbRemoveFromLayout  :GOSUB xpbRemoveFromLayout_Clicked
     END SELECT
  END SUB

  SUB xpbEditThisField_Clicked
     XuiSendMessage(grid, #GetTextString, 0,0,0,0, $xlSelectedField, @line$)
    IF(line$ == "") THEN EXIT SUB
    'Set all the shit to match the field
    GetFieldByName(line$, @index)
    CreateCallback(#CreateField, #Notify, index, 0,0,0,0,0)
    XuiSendMessage(#CreateField, #DisplayWindow,0,0,0,0,0,0)
  END SUB

   '1. Delete column
   '2. If successful, delete field from FieldList
   '3. Possibly delete child label
   '4. Resize records
   '5. Display current record again
   SUB xpbDeleteField_Clicked
     XuiSendMessage(grid, #GetTextString, 0,0,0,0, $xlSelectedField, @line$)
     IF(line$ == "") THEN EXIT SUB

     GetFieldByName(@line$, @index)

     IF(SQL_DeleteColumn(@line$)) THEN
       GetIndexByRecordNumber(0, @first, @last) 'current record size
       UpdateLayouts($$FALSE, index)
       DeleteField(index)
       ResizeRecords(UBOUND(FieldList[]), index, first, last)
       UpdateRuler($$RULER_CLEAR, $$FALSE)
       DrawRuler($$RULER_DRAW, #RulerMode)
     END IF

     DisplayRecord(#CurrentRecord, $$TRUE)
     XuiSendMessage(#CanvasGrid, #Redraw, 0,0,0,0,0,0)
     OrganizerCode(#Organizer, #Notify,0,0,0,0,0,0)
   END SUB

   SUB ChangeSelection
      selected_item = v0
      XuiSendMessage(grid, #GetTextArrayLine, v0, 0,0,0, kid, @field$)
      XuiSendMessage(grid, #SetTextString, 0,0,0,0, $xlSelectedField, @field$)
      XuiSendMessage(grid, #Redraw, 0,0,0,0, $xlSelectedField, 0)
   END SUB

   SUB xpbAddToLayout_Clicked
      XuiSendMessage(grid, #GetTextString, 0,0,0,0, $xlSelectedField, @line$)
      IF(line$ == "") THEN EXIT SUB
      #LayoutModified = $$TRUE
      GetFieldByName(@line$, @index)
      AddToLayout(index, $$ENTRY)
      GOSUB Update
      XuiSendMessage(#CanvasGrid, #Redraw, 0,0,0,0,0,0)
    END SUB

   SUB xpbRemoveFromLayout_Clicked
      XuiSendMessage(grid, #GetTextString, 0,0,0,0, $xlSelectedField, @line$)
      IF(line$ == "") THEN EXIT SUB
      #LayoutModified = $$TRUE
      GetFieldByName(@line$, @index)
      RemoveFromLayout(index, $$ENTRY)
      GOSUB Update
      XuiSendMessage(#CanvasGrid, #Redraw, 0,0,0,0,0,0)
   END SUB

   SUB xpbCreateNewFields_Clicked
     XuiSendMessage(#CreateField, #DisplayWindow, 0,0,0,0,0,0)
   END SUB
END FUNCTION

'  #######################
'  #####  Record ()  #####
'  #######################
'
FUNCTION  Record (grid, message, v0, v1, v2, v3, r0, (r1, r1$, r1[], r1$[]))
   STATIC  designX,  designY,  designWidth,  designHeight
   STATIC  SUBADDR  sub[]
   STATIC  upperMessage
   STATIC  Record
'
   $Record          =   0  ' kid   0 grid type = Record
   $xpbFirstRecord  =   1  ' kid   1 grid type = XuiPushButton
   $xpbBack         =   2  ' kid   2 grid type = XuiPushButton
   $xpbForward      =   3  ' kid   3 grid type = XuiPushButton
   $xpbLastRecord   =   4  ' kid   4 grid type = XuiPushButton
   $xcbMark         =   5  ' kid   5 grid type = XuiCheckBox
   $XuiLabel759     =   6  ' kid   6 grid type = XuiLabel
   $xrRecord        =   7  ' kid   7 grid type = XuiRange
   $xlOfNum         =   8  ' kid   8 grid type = XuiLabel
   $xpbNewRecord    =   9  ' kid   9 grid type = XuiPushButton
   $xpbSaveRecord   =  10  ' kid  10 grid type = XuiPushButton
   $xpbDiscard      =  11  ' kid  11 grid type = XuiPushButton
   $xpbDelete       =  12  ' kid  12 grid type = XuiPushButton
   $xpbHelp         =  13  ' kid  13 grid type = XuiPushButton
   $xlStatus        =  14
   $UpperKid        =  14  ' kid maximum
'
'
   IFZ sub[] THEN GOSUB Initialize
   IF XuiProcessMessage (grid, message, @v0, @v1, @v2, @v3, @r0, @r1, Record) THEN RETURN
   IF (message <= upperMessage) THEN GOSUB @sub[message]
   RETURN

  SUB Callback
     message = r1
     callback = message
     IF (message <= upperMessage) THEN GOSUB @sub[message]
  END SUB
  '
  '
  ' *****  Create  *****  v0123 = xywh : r0 = window : r1 = parent
  '
  SUB Create
     IF (v0 <= 0) THEN v0 = 0
     IF (v1 <= 0) THEN v1 = 0
     IF (v2 <= 0) THEN v2 = designWidth
     IF (v3 <= 0) THEN v3 = designHeight
     XuiCreateGrid  (@grid, Record, @v0, @v1, @v2, @v3, r0, r1, &Record())
     XuiSendMessage ( grid, #SetGridName, 0, 0, 0, 0, 0, @"Record")
     XuiPushButton  (@g, #Create, 8, 4, 56, 28, r0, grid)
     XuiSendMessage ( g, #SetCallback, grid, &Record(), -1, -1, $xpbFirstRecord, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xpbFirstRecord")
     XuiSendMessage ( g, #SetImage, 0, 0, 0, 0, 0, "." + $$PathSlash$ + "images" + $$PathSlash$ + "first_record.bmp")
     XuiSendMessage ( g, #SetImageCoords, 0, 0, 46, 40, 0, 0)

     XuiPushButton  (@g, #Create, 64, 4, 56, 28, r0, grid)
     XuiSendMessage ( g, #SetCallback, grid, &Record(), -1, -1, $xpbBack, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xpbBack")
     XuiSendMessage ( g, #SetImage, 0, 0, 0, 0, 0, "." + $$PathSlash$ + "images" + $$PathSlash$ + "prev_record.bmp")
     XuiSendMessage ( g, #SetImageCoords, 0, 0, 46, 40, 0, 0)

     XuiPushButton  (@g, #Create, 120, 4, 56, 28, r0, grid)
     XuiSendMessage ( g, #SetCallback, grid, &Record(), -1, -1, $xpbForward, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xpbForward")
     XuiSendMessage ( g, #SetImage, 0, 0, 0, 0, 0, "." + $$PathSlash$ + "images" + $$PathSlash$ + "next_record.bmp")
     XuiSendMessage ( g, #SetImageCoords, 0, 0, 46, 40, 0, 0)

     XuiPushButton  (@g, #Create, 176, 4, 56, 28, r0, grid)
     XuiSendMessage ( g, #SetCallback, grid, &Record(), -1, -1, $xpbLastRecord, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xpbLastRecord")
     XuiSendMessage ( g, #SetImage, 0, 0, 0, 0, 0, "." + $$PathSlash$ + "images" + $$PathSlash$ + "last_record.bmp")
     XuiSendMessage ( g, #SetImageCoords, 0, 0, 46, 40, 0, 0)

     XuiCheckBox    (@g, #Create, 244, 8, 64, 20, r0, grid)
     XuiSendMessage ( g, #SetCallback, grid, &Record(), -1, -1, $xcbMark, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xcbMark")
     XuiSendMessage ( g, #SetBorder, $$BorderNone, $$BorderNone, $$BorderRaise1, 0, 0, 0)
     XuiSendMessage ( g, #SetTexture, $$TextureNone, 0, 0, 0, 0, 0)
     XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"Mark")
     XuiLabel       (@g, #Create, 8, 40, 60, 20, r0, grid)
     XuiSendMessage ( g, #SetCallback, grid, &Record(), -1, -1, $XuiLabel759, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"XuiLabel759")
     XuiSendMessage ( g, #SetBorder, $$BorderNone, $$BorderNone, $$BorderNone, 0, 0, 0)
     XuiSendMessage ( g, #SetTexture, $$TextureLower1, 0, 0, 0, 0, 0)
     XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"Record:")
     XuiRange       (@g, #Create, 88, 40, 80, 20, r0, grid)
     XuiSendMessage ( g, #SetCallback, grid, &Record(), -1, -1, $xrRecord, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xrRecord")
     XuiSendMessage ( g, #SetBorder, $$BorderHiLine2, $$BorderHiLine2, $$BorderNone, 0, 0, 0)
     XuiSendMessage ( g, #SetIndent, 0, 0, 4, 0, 0, 0)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 1, @"Label")
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 2, @"Button0")
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 3, @"Button1")
     XuiLabel       (@g, #Create, 168, 40, 80, 20, r0, grid)
     XuiSendMessage ( g, #SetCallback, grid, &Record(), -1, -1, $xlOfNum, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xlOfNum")
     XuiSendMessage ( g, #SetBorder, $$BorderNone, $$BorderNone, $$BorderNone, 0, 0, 0)
     XuiPushButton  (@g, #Create, 12, 68, 56, 36, r0, grid)
     XuiSendMessage ( g, #SetCallback, grid, &Record(), -1, -1, $xpbNewRecord, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xpbNewRecord")
     XuiSendMessage ( g, #SetImage, 0, 0, 0, 0, 0, "." + $$PathSlash$ + "images" + $$PathSlash$ + "new_big.bmp")
     XuiSendMessage ( g, #SetImageCoords, 0, 0, 46, 40, 0, 0)
      XuiSendMessage (g, #SetHintString, 0,0,0,0,0, @"Add new record")

     XuiPushButton  (@g, #Create, 68, 68, 56, 36, r0, grid)
     XuiSendMessage ( g, #SetCallback, grid, &Record(), -1, -1, $xpbSaveRecord, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xpbSaveRecord")
     XuiSendMessage ( g, #SetImage, 0, 0, 0, 0, 0, "." + $$PathSlash$ + "images" + $$PathSlash$ + "save_big.bmp")
     XuiSendMessage ( g, #SetImageCoords, 0, 0, 46, 40, 0, 0)
     XuiSendMessage (g, #SetHintString, 0,0,0,0,0, @"Save current record")

     XuiPushButton  (@g, #Create, 124, 68, 56, 36, r0, grid)
     XuiSendMessage ( g, #SetCallback, grid, &Record(), -1, -1, $xpbDiscard, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xpbDiscard")
     XuiSendMessage ( g, #SetImage, 0, 0, 0, 0, 0, "." + $$PathSlash$ + "images" + $$PathSlash$ + "discard.bmp")
     XuiSendMessage ( g, #SetImageCoords, 0, 0, 46, 40, 0, 0)
      XuiSendMessage (g, #SetHintString, 0,0,0,0,0, @"Discard changes to current record")


     XuiPushButton  (@g, #Create, 180, 68, 56, 36, r0, grid)
     XuiSendMessage ( g, #SetCallback, grid, &Record(), -1, -1, $xpbDelete, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xpbDelete")
     XuiSendMessage ( g, #SetImage, 0, 0, 0, 0, 0, "." + $$PathSlash$ + "images" + $$PathSlash$ + "delete.bmp")
     XuiSendMessage ( g, #SetImageCoords, 0, 0, 46, 40, 0, 0)
      XuiSendMessage (g, #SetHintString, 0,0,0,0,0, @"Delete current record")

     XuiPushButton  (@g, #Create, 252, 76, 56, 20, r0, grid)
     XuiSendMessage ( g, #SetCallback, grid, &Record(), -1, -1, $xpbHelp, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xpbHelp")
     XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"Help")

     XuiLabel       (@g, #Create, 190, 40, 20, 20, r0, grid)
     XuiSendMessage ( g, #SetCallback, grid, &Record(), -1, -1, $XuiLabel759, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"XuiLabel759")
     XuiSendMessage ( g, #SetBorder, $$BorderNone, $$BorderNone, $$BorderNone, 0, 0, 0)
     XuiSendMessage ( g, #SetTexture, $$TextureLower1, 0, 0, 0, 0, 0)
     GOSUB Resize
  END SUB

  SUB CreateWindow
     IF (v0 == 0) THEN v0 = designX
     IF (v1 == 0) THEN v1 = designY
     IF (v2 <= 0) THEN v2 = designWidth
     IF (v3 <= 0) THEN v3 = designHeight
     XuiWindow (@window, #WindowCreate, v0, v1, v2, v3, r0, @r1$)
     v0 = 0 : v1 = 0 : r0 = window : ATTACH r1$ TO display$
     GOSUB Create
     r1 = 0 : ATTACH display$ TO r1$
     XuiWindow (window, #WindowRegister, grid, -1, v2, v3, @r0, @"Record")
  END SUB

  SUB GetSmallestSize
  END SUB

  SUB Redrawn
     XuiCallback (grid, #Redrawn, v0, v1, v2, v3, r0, r1)
  END SUB

  SUB Resize
  END SUB

  SUB Selection
  END SUB

  SUB Initialize
     XuiGetDefaultMessageFuncArray (@func[])
     XgrMessageNameToNumber (@"LastMessage", @upperMessage)
  '
     func[#Callback]           = &XuiCallback ()               ' disable to handle Callback messages internally
  ' func[#GetSmallestSize]    = 0                             ' enable to add internal GetSmallestSize routine
  ' func[#Resize]             = 0                             ' enable to add internal Resize routine
  '
     DIM sub[upperMessage]
  '  sub[#Callback]            = SUBADDRESS (Callback)         ' enable to handle Callback messages internally
     sub[#Create]              = SUBADDRESS (Create)           ' must be subroutine in this function
     sub[#CreateWindow]        = SUBADDRESS (CreateWindow)     ' must be subroutine in this function
  '  sub[#GetSmallestSize]     = SUBADDRESS (GetSmallestSize)  ' enable to add internal GetSmallestSize routine
     sub[#Redrawn]             = SUBADDRESS (Redrawn)          ' generate #Redrawn callback if appropriate
  '  sub[#Resize]              = SUBADDRESS (Resize)           ' enable to add internal Resize routine
     sub[#Selection]           = SUBADDRESS (Selection)        ' routes Selection callbacks to subroutine
  '
     IF sub[0] THEN PRINT "Record() : Initialize : error ::: (undefined message)"
     IF func[0] THEN PRINT "Record() : Initialize : error ::: (undefined message)"
     XuiRegisterGridType (@Record, "Record", &Record(), @func[], @sub[])
  '
  ' Don't remove the following 4 lines, or WindowFromFunction/WindowToFunction will not work
  '
     designX = 484
     designY = 103
     designWidth = 320
     designHeight = 116
  '
     gridType = Record
     XuiSetGridTypeProperty (gridType, @"x",                designX)
     XuiSetGridTypeProperty (gridType, @"y",                designY)
     XuiSetGridTypeProperty (gridType, @"width",            designWidth)
     XuiSetGridTypeProperty (gridType, @"height",           designHeight)
     XuiSetGridTypeProperty (gridType, @"maxWidth",         designWidth)
     XuiSetGridTypeProperty (gridType, @"maxHeight",        designHeight)
     XuiSetGridTypeProperty (gridType, @"minWidth",         designWidth)
     XuiSetGridTypeProperty (gridType, @"minHeight",        designHeight)
     XuiSetGridTypeProperty (gridType, @"can",              $$Focus OR $$Respond OR $$Callback)
     XuiSetGridTypeProperty (gridType, @"focusKid",         $xpbFirstRecord)
     IFZ message THEN RETURN
  END SUB
END FUNCTION


' ###########################
' #####  RecordCode ()  #####
' ###########################
FUNCTION  RecordCode (grid, message, v0, v1, v2, v3, kid, r1)
   SHARED FIELD FieldList[]
   SHARED RECORD RecordList[]
   SHARED MODE Mode
   XLONG update
   $Record          =   0  ' kid   0 grid type = Record
   $xpbFirstRecord  =   1  ' kid   1 grid type = XuiPushButton
   $xpbBack         =   2  ' kid   2 grid type = XuiPushButton
   $xpbForward      =   3  ' kid   3 grid type = XuiPushButton
   $xpbLastRecord   =   4  ' kid   4 grid type = XuiPushButton
   $xcbMark         =   5  ' kid   5 grid type = XuiCheckBox
   $XuiLabel759     =   6  ' kid   6 grid type = XuiLabel
   $xrRecord        =   7  ' kid   7 grid type = XuiRange
   $xlOfNum         =   8  ' kid   8 grid type = XuiLabel
   $xpbNewRecord    =   9  ' kid   9 grid type = XuiPushButton
   $xpbSaveRecord   =  10  ' kid  10 grid type = XuiPushButton
   $xpbDiscard      =  11  ' kid  11 grid type = XuiPushButton
   $xpbDelete       =  12  ' kid  12 grid type = XuiPushButton
   $xpbHelp         =  13  ' kid  13 grid type = XuiPushButton
    $xlStatus        =  14
   $UpperKid        =  14  ' kid maximum
   $xlMode = 23 'mode lable string in GeoFile
'
   update = $$FALSE
   IF (message == #Callback) THEN message = r1
'
   SELECT CASE message
      CASE #Selection      : GOSUB Selection
      CASE #CloseWindow : XuiSendMessage (grid, #HideWindow, 0, 0, 0, 0, 0, 0)
   END SELECT

   RETURN

  SUB Selection
     SELECT CASE kid
        CASE $Record          :
        CASE $xpbFirstRecord  :GOSUB xpbFirstRecord_Clicked
        CASE $xpbBack         :GOSUB xpbBack_Clicked
        CASE $xpbForward      :GOSUB xpbForward_Clicked
        CASE $xpbLastRecord   :GOSUB xpbLastRecord_Clicked
        CASE $xcbMark         :GOSUB xcbMarkRecord_Clicked
        CASE $xrRecord        :GOSUB xrRecord_Clicked
        CASE $xpbNewRecord    :GOSUB xpbNewRecord_Clicked
        CASE $xpbSaveRecord   :GOSUB xpbSaveRecord_Clicked
        CASE $xpbDiscard      :GOSUB xpbDiscard_Clicked
        CASE $xpbDelete       :GOSUB xpbDeleteRecord_Clicked
        CASE $xpbHelp         :Help()
     END SELECT
  END SUB

  SUB xcbMarkRecord_Clicked
    MarkRecord(#CurrentRecord, v0)
    IF(#ShowOnlyMarked) THEN
      record = GetFirstRecord(GetOrderIndex(record), $$GET_MARKED)
      UpdateShowMarked(record)
      GetModeString(@mode$)
      XuiSendMessage(#GeoFile, #SetTextString, 0,0,0,0, $xlMode, @mode$)
      XuiSendMessage(#GeoFile, #Redraw, 0,0,0,0, $xlMode, @mode$)
    END IF
  END SUB

  SUB xpbDiscard_Clicked
    IF(RecordList[#CurrentRecord].modified) THEN
      msg$ = "Are you sure you want to\ndiscard the changes\nto this record?"
      IF(AskYesNo(@msg$)) THEN
        RecordList[#CurrentRecord].modified = $$FALSE
        DisplayRecord(#CurrentRecord, $$TRUE)
      END IF
    END IF
  END SUB

   SUB xrRecord_Clicked
     GOSUB UpdateRecord
     IF(update) THEN
       SELECT CASE TRUE
         CASE v1 == 1 : GOSUB xpbForward_Clicked
         CASE v1 == -1: GOSUB xpbBack_Clicked
       END SELECT
     END IF
   END SUB

   SUB xpbSaveRecord_Clicked
     GOSUB UpdateRecord
     IF(update) THEN
       SaveRecord(#CurrentRecord)
       DisplayRecord(#CurrentRecord, $$TRUE)
     END IF
   END SUB

   SUB xpbDeleteRecord_Clicked
     order = GetOrderIndex(#CurrentRecord)
     IF(DeleteRecord(#CurrentRecord)) THEN
       record = GetRecord(order)

       IF(#ShowOnlyMarked) THEN
         IF(record != -1) THEN
           IF(RecordList[record].marked == $$FALSE) THEN
             rec2 = GetNextRecord(order, $$GET_MARKED)
             IF(rec2 != -1) THEN record = rec2
           END IF
         END IF
       END IF

       DisplayRecord(record, $$TRUE)
     END IF
   END SUB

   SUB xpbNewRecord_Clicked
      GOSUB UpdateRecord
      IF(update) THEN
        ClearFields()
        AddRecord(@record, $$TRUE, 0)
        DisplayRecord(#CurrentRecord, $$TRUE)
      END IF
   END SUB

   SUB xpbForward_Clicked
     GOSUB UpdateRecord
     IF(update) THEN
       IF(#ShowOnlyMarked) THEN
         record = GetNextRecord(GetOrderIndex(#CurrentRecord), $$GET_MARKED)
       ELSE
         record = GetNextRecord(GetOrderIndex(#CurrentRecord), $$GET_ORDINAL)
       END IF
       IF(record != -1) THEN #CurrentRecord = record
       DisplayRecord(#CurrentRecord, $$TRUE)
     END IF
   END SUB

   SUB xpbBack_Clicked
     GOSUB UpdateRecord
     IF(update) THEN
       IF(#ShowOnlyMarked) THEN
         record = GetPreviousRecord(GetOrderIndex(#CurrentRecord), $$GET_MARKED)
       ELSE
         record = GetPreviousRecord(GetOrderIndex(#CurrentRecord), $$GET_ORDINAL)
       END IF
       IF(record != -1) THEN #CurrentRecord = record
       DisplayRecord(#CurrentRecord, $$TRUE)
     END IF
   END SUB

   SUB xpbFirstRecord_Clicked
     GOSUB UpdateRecord
     IF(update) THEN
       IF(#ShowOnlyMarked) THEN
         record = GetFirstRecord(GetOrderIndex(#CurrentRecord), $$GET_MARKED)
       ELSE
         record = GetFirstRecord(GetOrderIndex(#CurrentRecord), $$GET_ORDINAL)
       END IF
       IF(record != -1) THEN #CurrentRecord = record
       DisplayRecord(#CurrentRecord, $$TRUE)
     END IF
   END SUB

   SUB xpbLastRecord_Clicked
     GOSUB UpdateRecord
     IF(update) THEN
       IF(#ShowOnlyMarked) THEN
         record = GetLastRecord(GetOrderIndex(#CurrentRecord), $$GET_MARKED)
       ELSE
         record = GetLastRecord(GetOrderIndex(#CurrentRecord), $$GET_ORDINAL)
       END IF
       IF(record != -1) THEN #CurrentRecord = record
       DisplayRecord(#CurrentRecord, $$TRUE)
     END IF
   END SUB

   SUB UpdateRecord
     update = UpdateCurrentRecord(#CurrentRecord)
     IF(update) THEN
       RecordList[#CurrentRecord].modified = $$FALSE
     ELSE

     END IF
   END SUB
END FUNCTION

'Callback for all fields
FUNCTION FieldCallback(grid, message, v0, v1, v2, v3, kid, r1)
   SHARED RECORD RecordList[]

   IF(message == #Callback) THEN message = r1
   SELECT CASE message
      CASE #TextEvent: GOSUB HandleTextEvent
   END SELECT

   SUB HandleTextEvent
     key = UBYTEAT(&v2, 3)
     IF(key >= $$KeyF1) THEN
          RETURN
     END IF
     GOSUB ValidateTextInput
   END SUB

  SUB ValidateTextInput
     SELECT CASE TRUE
       CASE key == $$KeyBackspace   : GOSUB MarkModified
       CASE key == $$KeyClear       : GOSUB MarkModified
       CASE key == $$KeyEnter       : GOSUB MarkModified
       CASE key == $$KeySpace       : GOSUB MarkModified
       CASE key == $$KeyDelete      : GOSUB MarkModified
       CASE key >= $$Key0 && key <= $$KeyZ            : GOSUB MarkModified
       CASE key >= $$KeyPad0 && key <= $$KeyPadDivide : GOSUB MarkModified
     END SELECT
   END SUB

   SUB MarkModified
     IF(RecordList[#CurrentRecord].modified) THEN EXIT SUB
     #UpdateSummaryFields = $$TRUE
     RecordList[#CurrentRecord].modified = $$TRUE
     RETURN
   END SUB
END FUNCTION
'
'
' #########################
' #####  AddField ()  #####
' #########################
'
' min/max doubles as width/height for images
'
' Returns the grid number of the created field, and the index
' of the auto-generated label in child, if any
'
FUNCTION  AddField (name$, type, size, resize, add_to_db, DOUBLE min, DOUBLE max)
  STATIC x
  STATIC y
  STATIC grid_height
  SHARED FIELD FieldList[]
  SHARED StringData$[]
  XLONG font_width
  XLONG foo
  XLONG window
  XLONG g
  XLONG width
  XLONG height
  XLONG gx
  XLONG gy

  y = 0
  FOR g = 0 TO UBOUND(FieldList[])
    IF(FieldList[g].in_layout) THEN
      IF(FieldList[g].y >= y) THEN y = FieldList[g].y + FieldList[g].h + 5
    END IF
  NEXT g
  g = 0
  IF(y == 0) THEN y = 10

  SELECT CASE type
    CASE $$FT_STRING_MULTI       : IF((y +  $$FIELD_HEIGHT_MULTI) > #PageHeight ) THEN y = 10
    CASE $$FT_STRING_SINGLE      : IF((y +  $$FIELD_HEIGHT_SINGLE) > #PageHeight ) THEN y = 10
    CASE $$FT_INTEGER            : IF((y +  $$FIELD_HEIGHT_SINGLE) > #PageHeight ) THEN y = 10
    CASE $$FT_SUMMARY            : IF((y +  $$FIELD_HEIGHT_SINGLE) > #PageHeight ) THEN y = 10
    CASE $$FT_REAL               : IF((y +  $$FIELD_HEIGHT_SINGLE) > #PageHeight ) THEN y = 10
    CASE $$FT_DATE               : IF((y +  $$FIELD_HEIGHT_SINGLE) > #PageHeight ) THEN y = 10
    CASE $$FT_IMAGE              : IF((y +  $$FIELD_HEIGHT_IMAGE) > #PageHeight ) THEN y = 10
  END SELECT

  XgrGetGridWindow(#GeoFile, @window)

  ' Get current record size, then resize
  IF (resize) THEN
    GetIndexByRecordNumber (0, @first, @last)
  END IF

  REDIM FieldList[UBOUND(FieldList[]) + 1]
  index = UBOUND(FieldList[])

  IF(add_to_db) THEN
    child = AddLabel(name$, 10, y, $$FIELD_WIDTH, $$FIELD_HEIGHT_SINGLE, $$TRUE, @label_width)
  END IF

  SELECT CASE type
    CASE $$FT_STRING_MULTI       : GOSUB AddMultiLine
    CASE $$FT_STRING_SINGLE      : GOSUB AddSingleLine
    CASE $$FT_INTEGER            :
      FieldList[index].int_min = GIANT(min)
      FieldList[index].int_max = GIANT(max)
      GOSUB AddSingleLine
    CASE $$FT_SUMMARY            : GOSUB AddSingleLine
    CASE $$FT_REAL               :
      FieldList[index].real_min = DOUBLE(min)
      FieldList[index].real_max = DOUBLE(max)
      GOSUB AddSingleLine
    CASE $$FT_DATE               : GOSUB AddSingleLine
    CASE $$FT_IMAGE              : GOSUB AddImage
  END SELECT

  'Update Organizer. Move this to a grid function sub
  XuiSendMessage(#Organizer, #GetTextArray, 0,0,0,0, 1, @lines$[])
  REDIM lines$[UBOUND(lines$[]) + 1]
  lines$[UBOUND(lines$[])] = name$
  XuiSendMessage(#Organizer, #SetTextArray, 0,0,0,0, 1, @lines$[])
  XuiSendMessage(#Organizer, #Redraw, 0,0,0,0, 1, 0)

  'Update MarkRecords
  MarkRecordsCode(#MarkRecords, #Notify, 0,0,0,0,0,0)

  XuiSendMessage(#CanvasGrid, #SelectWindow, 0,0,0,0,0,0)
  XuiSendMessage (#GeoFile, #Redraw, 0,0,0,0, $$CANVAS_GRID, 0)

  #UpdateSummaryFields = $$TRUE

  RETURN g

'############## SUBROUTINES ###############

  SUB AddImage
    FieldList[index].grid_type = $$IMAGE
    IF(min == 0 && max == 0) THEN
      w = $$FIELD_WIDTH_IMAGE : h = $$FIELD_HEIGHT_IMAGE
    ELSE
      w = min : h = max
    END IF
    XuiLabel    (@g, #Create, 10 + label_width, y, w, h, window, #CanvasGrid)
    XuiSendMessage ( g, #SetBorder, $$BorderLoLine1, $$BorderLoLine1, $$BorderNone, 0, 0, 0)
    XgrSetGridClip(g, #CanvasGrid)
    GOSUB FinishField
  END SUB

  SUB AddMultiLine
    XuiTextArea    (@g, #Create, 10 + label_width, y, $$FIELD_WIDTH, $$FIELD_HEIGHT_MULTI, window, #CanvasGrid)
    IF(#NoScrollbars) THEN
      XuiSendMessage ( g, #Destroy, 0, 0, 0, 0, 2, 0)
      XuiSendMessage ( g, #Destroy, 0, 0, 0, 0, 3, 0)
      XuiSendMessage ( g, #SetSize, 2, 2, $$FIELD_WIDTH, $$FIELD_HEIGHT_MULTI, 1, 0)
    END IF
    GOSUB FinishTextField
  END SUB

  SUB AddSingleLine
    XuiTextLine    (@g, #Create, 10 + label_width, y, $$FIELD_WIDTH, $$FIELD_HEIGHT_SINGLE, window, #CanvasGrid)
    XuiSendMessage ( g, #SetAlign, $$AlignCenter, 0, -1, -1, 0, 0)
    GOSUB FinishTextField
  END SUB

  SUB FinishTextField
    FieldList[index].grid_type = $$ENTRY
    XuiSendMessage ( g, #SetColor, $$White, $$Black, $$Black, $$White, 0, 0)
    XuiSendMessage ( g, #SetBorder, $$BorderLoLine1, $$BorderLoLine1, $$BorderNone, 0, 0, 0)
    XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 1, @"foo")
    XuiSendMessage ( g, #SetColor, $$White, $$Black, $$Black, $$White, 1, 0)
    XuiSetCallback (g, #SetCallback, g, &FieldCallback(), -1, -1, 1, 0)

    'Clip Text Fields to canvas
    XgrSetGridClip(g, #CanvasGrid)
    GOSUB FinishField
  END SUB

  SUB FinishField
    XuiSendMessage(g, #GetFontNumber, @b1, 0,0,0, 0, 0)
    XgrGetFontInfo(b1, @fname$, @fsize, @fweight, @fitalic, @fangle)
    FieldList[index].fontSize = fsize
    FieldList[index].fontWeight = fweight
    FieldList[index].fontItalic = fitalic
    FieldList[index].fontAngle = fangle
    FieldList[index].fontName = fname$
    XuiSendMessage(g, #GetColor, @b1, @b2, @b3, @b4, 0, 0)
    FieldList[index].backcolor = b1
    FieldList[index].textcolor = b2
    FieldList[index].lowcolor = b3
    FieldList[index].highcolor = b4
    XuiSendMessage(g, #GetBorder, @b1, @b2, @b3, @b4, 0, 0)
    FieldList[index].border1 = b1
    FieldList[index].border2 = b2
    FieldList[index].border3 = b3
    FieldList[index].border4 = b4
    XgrGetGridPositionAndSize(g, @gx, @gy, @width, @grid_height)
    FieldList[index].x = gx
    FieldList[index].y = gy
    FieldList[index].w = width
    FieldList[index].h = grid_height
    FieldList[index].selected = $$FALSE
    FieldList[index].grid = g
    FieldList[index].name = name$
    FieldList[index].size = size
    FieldList[index].min = XLONG(min)
    FieldList[index].max = XLONG(max)
    FieldList[index].type = type
    FieldList[index].in_layout = $$TRUE

    'Check visibility
    IF(IsFieldVisible(FieldList[index]) == $$FALSE) THEN
     ' MakeFieldVisible(index)
    END IF
    FieldList[index].visible = $$TRUE

    ' Add field to database
    IF(add_to_db) THEN
      SQL_AddColumn(name$, type, size)
      SaveLayout(#CurrentLayout$)
    END IF

    'If first field added to a new database, create a record now
    IF(#FirstField) THEN
      AddRecord(@foo, $$TRUE, 0)
      #FirstField = $$FALSE
      EXIT SUB
    END IF

    IF(resize) THEN
      ResizeRecords(index, index, first, last)
    END IF
  END SUB


END FUNCTION

'CEO for #GeoFile window
'
FUNCTION  GeoFileCEO (grid, message, v0, v1, v2, v3, r0, r1)
  SHARED FIELD FieldList[]
  SHARED FIELD LabelList[]
  SHARED FIELD ObjectList[]
  SHARED RECORD RecordList[]
  SHARED SEL_LIST SelList[]
  POINT delta
	$xpbBack = 2
  $xpbForward = 3

  IFZ(#CurrentProject$) THEN RETURN

  SELECT CASE message
    CASE #WindowMouseDown, #WindowMouseDrag, #WindowMouseUp, #WindowMouseWheel:
      GOSUB MouseHandler
    CASE #WindowMouseMove:
      GOSUB MouseMove
    CASE #WindowKeyDown:
      GOSUB KeyboardHandler
    CASE #WindowMinimized:
      CloseAllTearoffs()
      IF(#DesignMode) THEN
        XuiSendMessage(#Organizer, #HideWindow,0,0,0,0,0,0)
      ELSE
        XuiSendMessage(#Record, #HideWindow, 0,0,0,0,0,0)
      END IF
    CASE #WindowSelected:
      IF(#DesignMode) THEN
        XuiSendMessage(#Organizer, #ShowWindow, 0,0,0,0,0,0)
        DrawSelectionRectangle(@SelList[])
      ELSE
        IF(#PrintActive == $$FALSE) THEN XuiSendMessage(#Record, #ShowWindow, 0,0,0,0,0,0)
      END IF
  END SELECT

  IF(SelList[] && #DesignMode && message != #WindowMouseMove) THEN
    DrawSelectionRectangle(@SelList[])
  END IF
  RETURN

  '######## SUBROUTINES ##########

  SUB KeyboardHandler
    key = UBYTEAT(&v2, 3)

    SELECT CASE key
      CASE $$KeyDelete     : GOSUB HandleDelete
      CASE $$KeyTab        : GOSUB CheckShift : GOSUB HandleTab
      CASE $$KeyLeftArrow  : GOSUB HandleArrow
      CASE $$KeyDownArrow  : GOSUB HandleArrow
      CASE $$KeyRightArrow : GOSUB HandleArrow
      CASE $$KeyUpArrow    : GOSUB HandleArrow
      CASE ELSE            : GOSUB HandleOther
    END SELECT
  END SUB

  'Allow resizing of fields
  SUB HandleArrow
    IF(#DesignMode && #SelectedGrid > 0) THEN
      GOSUB CheckShift
      GOSUB CheckCtrl
      'Check state of Ctrl key
      IF(ctrl == $$FALSE) THEN
        GOSUB MoveFields
        XuiSendMessage(#CanvasGrid, #Redraw, 0,0,0,0,0,0)
      ELSE
        GOSUB ResizeField
      END IF

      DrawSelectionRectangle(@SelList[])
      #LayoutModified = $$TRUE
      r0 = -1
      RETURN
    ELSE
      GOSUB HandleOther
    END IF
  END SUB

  SUB MoveFields
    IF(shift) THEN
      x = 5
    ELSE
      x = 1
    END IF
    SELECT CASE key
      CASE $$KeyLeftArrow  : delta.x = -x : delta.y = 0
      CASE $$KeyRightArrow : delta.x = x  : delta.y = 0
      CASE $$KeyDownArrow  : delta.x = 0  : delta.y = x
      CASE $$KeyUpArrow    : delta.x = 0  : delta.y = -x
    END SELECT
    MoveSelectedObjects(@SelList[], delta)
  END SUB

  SUB ResizeField
    IF(GetFieldByGrid(#SelectedGrid, @index)) THEN
      IF(shift) THEN
        x = 5
      ELSE
        x = 1
      END IF
      SELECT CASE key
        CASE $$KeyLeftArrow  : ResizeField(index, -x, 0)
        CASE $$KeyRightArrow : ResizeField(index, x, 0)
        CASE $$KeyDownArrow  : ResizeField(index, x, 1)
        CASE $$KeyUpArrow    : ResizeField(index, -x, 1)
      END SELECT
    END IF
  END SUB

  SUB HandleOther
    'Ignore keystrokes in fields in DesignMode
    IF(#DesignMode) THEN r0 = -1 : RETURN
    XuiGetKeyboardFocusGrid(#CanvasGrid, #GetKeyboardFocusGrid, @grid,0,0,0,0,0)
    GetFieldByGrid(grid, @index)
    IF(index >= 0) THEN
      SELECT CASE FieldList[index].type
        CASE $$FT_STRING_SINGLE:
          XuiSendMessage(grid, #GetTextString, 0,0,0,0,0, @line$)
          GOSUB CheckLine
        CASE $$FT_STRING_MULTI:
          XuiSendMessage(grid, #GetTextArray, 0,0,0,0,0, @lines$[])
          XstStringArrayToString(@lines$[], @line$)
          GOSUB CheckLine
      END SELECT
    END IF
  END SUB

  'Handle tab by calculation of x,y position
  SUB HandleTab
    'Handle Tab key
    IF(message == #WindowKeyDown) THEN
      IF(shift) THEN
        dir = $$UP
      ELSE
        dir = $$DOWN
      END IF
      IF(#DesignMode) THEN
			  IF(UBOUND(SelList[]) == 0 && #SelectedGrid != 0) THEN
          'Populates ObjectList[]!!!
					GetNextField(SelList[0].index, @y, dir, $$TRUE)
					IF(y != -1) THEN
						#SelectedGrid = ObjectList[y].grid
						SelList[0].grid = #SelectedGrid
            SelList[0].type = ObjectList[y].grid_type
            IF(ObjectList[y].grid_type == $$LABEL || ObjectList[y].grid_type == $$STATIC_IMAGE) THEN
							GetLabelByGrid(ObjectList[y].grid, @y)
            END IF
            SelList[0].index = y
						FieldPropertiesCode(#FieldProperties, #Notify,0,0,0,0,0,0)
						XuiSendMessage(#CanvasGrid, #Redraw, 0,0,0,0,0,0)
						DrawSelectionRectangle(@SelList[])
					END IF
				END IF
      ELSE
        XuiGetKeyboardFocusGrid(#CanvasGrid, #GetKeyboardFocusGrid, @grid,0,0,0,0,0)
        IF(GetFieldByGrid(grid, @index)) THEN
          'Populates ObjectList[]!!!!
          GetNextField(index, @x, dir, $$FALSE)
          IF(x != -1) THEN
            XuiSendMessage(#CanvasGrid, #SetKeyboardFocusGrid, FieldList[x].grid, 0,0,0,0,0)
          END IF
        END IF
      END IF
      'Free ObjectList[]
      REDIM ObjectList[]
    END IF
    r0 = -1
  END SUB

  SUB CheckShift
    XgrGetMouseInfo(@window, @grid, @x, @y, @state, @time)
    IF(state{1,16} == 1) THEN
      shift = $$TRUE
    ELSE
      shift = $$FALSE
    END IF
  END SUB

  SUB CheckCtrl
    XgrGetMouseInfo(@window, @grid, @x, @y, @state, @time)
    IF(state{1,17} == 1) THEN
      ctrl = $$TRUE
    ELSE
      ctrl = $$FALSE
    END IF
  END SUB

  SUB HandleDelete
    IF(#DesignMode) THEN
      r0 = -1
      IF(DeleteSelectedLabels(@SelList[])) THEN
        #SelectedGrid = 0
        REDIM SelList[]
        UpdateRuler($$RULER_CLEAR, $$FALSE)
        DrawRuler($$RULER_DRAW, #RulerMode)
        XuiSendMessage(#CanvasGrid, #Redraw, 0,0,0,0,0,0)
      END IF
      RETURN
    END IF
  END SUB

  'Limit line length to the length specified
  'for that field. Allow navigation/editing keys
  SUB CheckLine
    IF(LEN(line$) >= FieldList[index].size) THEN
      SELECT CASE key
        CASE $$KeyEnter     : RETURN
        CASE $$KeyLeftArrow : RETURN
        CASE $$KeyBackspace : RETURN
        CASE $$KeyDelete    : RETURN
        CASE $$KeyRightArrow: RETURN
      END SELECT
      r0 = -1
      RETURN
    ELSE
      RETURN
    END IF
  END SUB

  SUB MouseHandler
		SELECT CASE message
			CASE #WindowMouseWheel:
				GOSUB MouseWheel
			CASE ELSE:
				SELECT CASE #MouseMode
					CASE $$SELECTION: Select(message, @r0)
				END SELECT
		END SELECT
  END SUB

  'Kludgey, but works
  SUB MouseWheel
		IFZ(#DesignMode) THEN
		  IF(v3 < 0) THEN
				RecordCode(#Record, #Callback, 0,0,0,0, $xpbForward, #Selection)
			ELSE
				RecordCode(#Record, #Callback, 0,0,0,0, $xpbBack, #Selection)
			END IF
		ELSE
			'Fake a Tab keypress
			IF(v3 < 0) THEN
        shift = $$FALSE
				message = #WindowKeyDown
				GOSUB HandleTab
      ELSE
        shift = $$TRUE
        message = #WindowKeyDown
        GOSUB HandleTab
		  END IF
	  END IF
	END SUB

  SUB MouseMove
    IF(#DesignMode && #SelectedGrid == 0) THEN UpdateRuler($$RULER_DRAW, $$TRUE)
  END SUB
END FUNCTION

' ################################
' #####  IsFieldSelected ()  #####
' ################################
'
FUNCTION  IsFieldSelected (grid, @index)
  SHARED FIELD FieldList[]

  the_grid = 0
  FOR i = 0 TO UBOUND(FieldList[])
    IF(FieldList[i].visible && FieldList[i].in_layout) THEN
      the_grid = FieldList[i].grid
      IF(grid == the_grid) THEN
        FieldList[i].selected = $$TRUE
        index = i
        RETURN $$TRUE
      END IF
      XuiGetKidArray(the_grid, #GetKidArray, @g, @parent, 0,0,0, @kids[])
      IF(kids[]) THEN
        FOR z = 1 TO UBOUND(kids[])
          IF(grid == kids[z]) THEN
            FieldList[i].selected = $$TRUE
            index = i
            RETURN $$TRUE
          END IF
        NEXT z
      END IF
    END IF
  NEXT i

  RETURN $$FALSE

END FUNCTION

' ################################
' #####  IsLabelSelected ()  #####
' ################################
'
FUNCTION  IsLabelSelected (grid, @index)
   SHARED FIELD LabelList[]

   FOR i = 0 TO UBOUND(LabelList[])
     IF(LabelList[i].visible && LabelList[i].in_layout) THEN
        IF(grid == LabelList[i].grid) THEN
          LabelList[i].selected = $$TRUE
          index = i
          RETURN $$TRUE
        END IF
     END IF
   NEXT i

   RETURN $$FALSE

END FUNCTION

' #######################################
' #####  DrawSelectionRectangle ()  #####
' #######################################
'
' Draw selection border, and update ruler
'
FUNCTION  DrawSelectionRectangle (SEL_LIST list[])
  SHARED FIELD FieldList[]
  SHARED FIELD LabelList[]
  RECTANGLE r

  IFZ(list[]) THEN
    UpdateRuler($$RULER_CLEAR, $$FALSE) : DrawRuler($$RULER_DRAW, #RulerMode)
    RETURN
  END IF

  FOR i = 0 TO UBOUND(list[])
    SELECT CASE list[i].type
      CASE $$ENTRY: GetFieldSR(FieldList[list[i].index], @r)
      CASE $$IMAGE: GetFieldSR(FieldList[list[i].index], @r)
      CASE $$LABEL: GetFieldSR(LabelList[list[i].index], @r)
      CASE $$STATIC_IMAGE : GetFieldSR(LabelList[list[i].index], @r)
    END SELECT
    FOR z = -3 TO -1
      x1 = r.start.x - z - 1 : x2 = r.end.x + z
      y1 = r.start.y - z - 1 : y2 = r.end.y + z
      XgrDrawBoxGrid(#CanvasGrid, $$Blue, x1, y1, x2, y2)
    NEXT z
  NEXT i
  UpdateRuler($$RULER_DRAW_BOX, $$FALSE)
END FUNCTION

' ################################
' #####  UpdateCurrentRecord ()  #
' ################################
'
FUNCTION  UpdateCurrentRecord (record)
   SHARED FIELD FieldList[]
   SHARED RECORD RecordList[]
   SHARED StringData$[]
   $decimal = 0x2E
   $minus = 0x2D
   $plus = '+'
   $e = 'e'
   allow_decimal = $$FALSE
   allow_e = $$FALSE
   allow_plus = $$FALSE
   alpha_ok = $$FALSE

   IF(record < 0) THEN
     Log($$LOG_DEBUG, "UpdateCurrentRecord(): record < 0!")
     RETURN
   END IF
   IF(RecordList[record].modified) THEN
     RecordList[record].dirty = $$TRUE
   END IF
   first = RecordList[record].first
   last = RecordList[record].last

   FOR index = 0 TO UBOUND(FieldList[])
     'Only update fields that are in the current layout
     IF(FieldList[index].in_layout) THEN
       grid = FieldList[index].grid
       SELECT CASE FieldList[index].type
        CASE $$FT_STRING_MULTI:
          XuiSendMessage(grid, #GetTextArray, 0,0,0,0,0,@data$[])
          XstStringArrayToString(@data$[], @temp$)
          StringData$[first + index] = temp$
        CASE $$FT_STRING_SINGLE:
          XuiSendMessage(grid, #GetTextString, 0,0,0,0,0,@temp$)
          StringData$[first + index] = temp$
        CASE $$FT_DATE:
          XuiSendMessage(grid, #GetTextString, 0,0,0,0,0,@temp$)
          GOSUB ValidateDate
          StringData$[first + index] = temp$
        CASE $$FT_INTEGER:
          XuiSendMessage(grid, #GetTextString, 0,0,0,0,0, @temp$)
          GOSUB ValidateIntField
          StringData$[first + index] = temp$
        CASE $$FT_REAL:
          XuiSendMessage(grid, #GetTextString, 0,0,0,0,0, @temp$)
          GOSUB ValidateRealField
          StringData$[first + index] = temp$
        CASE $$FT_SUMMARY:
       END SELECT
     END IF
   NEXT index

  RETURN $$TRUE


'############# SUBS ################

  'Simple date validation
  'Allow empty date field
  SUB ValidateDate
    IF(temp$ == "") THEN EXIT SUB
    Tokenize(temp$, @out$[], $$DATE_DELIMITERS$)
    IF(UBOUND(out$[]) != 2) THEN
      Log($$LOG_INFO, "Invalid date format!")
      ShowMessage("Invalid date format!\nValid format: [m]m{/-.}[d]d{/-.}[yyy]y")
      RETURN $$FALSE
    END IF

    IF(LEN(out$[0]) > 2 || LEN(out$[1]) > 2 || LEN(out$[2]) > 4) THEN
      Log($$LOG_INFO, "Invalid date format!")
      ShowMessage("Invalid date format!\nValid format: [m]m{/-.}[d]d{/-.}[yyy]y")
      RETURN $$FALSE
    END IF

    FOR z = 0 TO 2
      FOR i = 0 TO LEN(out$[z]) - 1
        char = out$[z]{i}
        IF(char < 0x30 || char > 0x39) THEN
          Log($$LOG_INFO, "Non-numeric character in date!")
          ShowMessage(@"Non-numeric character in date!")
          RETURN $$FALSE
        END IF
      NEXT i
    NEXT z

    month = XLONG(out$[0])
    day = XLONG(out$[1])
    year = XLONG(out$[2])
    IF(month < 1 || month > 12) THEN
      Log($$LOG_INFO, "Invalid month!")
      ShowMessage("Invalid month: " + STRING$(month))
      RETURN $$FALSE
    END IF

    IF(day < 1 || day > 31) THEN
      Log($$LOG_INFO, "Invalid day!")
      ShowMessage("Invalid day: " + STRING$(day))
      RETURN $$FALSE
    END IF

    IF(year < 1) THEN
      Log($$LOG_INFO, "Invalid year!")
      ShowMessage("Invalid year: " + STRING$(year))
      RETURN $$FALSE
    END IF

  END SUB

  SUB ValidateIntField
    GOSUB CheckForAlpha
    IFZ(alpha_ok) THEN
      ShowMessage("Number Format Error in field: " + FieldList[index].name)
      RETURN $$FALSE
    END IF
    IF(FieldList[index].int_max > FieldList[index].int_min) THEN
      SELECT CASE TRUE
        CASE temp$ == "", GIANT(temp$) < FieldList[index].int_min :
           msg$ = "Field: " + FieldList[index].name + "\ninteger value is less than" + STR$(FieldList[index].int_min)
           ShowMessage(@msg$)
           RETURN $$FALSE
        CASE GIANT(temp$) > FieldList[index].int_max :
           msg$ = "Field: " + FieldList[index].name + "\ninteger value is greater than" + STR$(FieldList[index].int_max)
           ShowMessage(@msg$)
           RETURN $$FALSE
      END SELECT
    END IF
  END SUB

  SUB ValidateRealField
    allow_decimal = $$TRUE
    allow_e = $$TRUE
    allow_plus = $$TRUE

    GOSUB CheckForAlpha
    IFZ(alpha_ok) THEN
      ShowMessage("Number Format Error in field: " + FieldList[index].name)
      RETURN $$FALSE
    END IF

    IF(FieldList[index].real_max > FieldList[index].real_min) THEN
      SELECT CASE TRUE
        CASE temp$ == "", DOUBLE(temp$) < FieldList[index].real_min :
          msg$ = "Field: " + FieldList[index].name + "\nreal value is less than" + STR$(FieldList[index].real_min)
          ShowMessage(@msg$)
          RETURN $$FALSE
        CASE DOUBLE(temp$) > FieldList[index].real_max :
          msg$ = "Field: " + FieldList[index].name + "\nreal value is greater than" + STR$(FieldList[index].real_max)
          ShowMessage(@msg$)
          RETURN $$FALSE
      END SELECT
    END IF
  END SUB

  'Some minimal effort made to validate proper number formats
  'this really is a regular expression, for floats:
  ' [-]{0-9}.{0-9}
  'oh well, Im lazy.
  'This is shit and needs to be redone
  SUB CheckForAlpha
    alpha_ok = $$FALSE
     FOR i = 0 TO LEN(temp$) - 1
      char = temp${i}
      IF(char < 0x30 || char > 0x39) THEN

        IF(char != $minus && char != $decimal && char != $e && char != $plus) THEN
          Log($$LOG_DEBUG, "non-numeric character found!")
          EXIT SUB
        END IF

        'Doesnt bother checking where the e is
        IF(char == $e && allow_e == $$FALSE) THEN
          Log($$LOG_DEBUG, "e not allowed!")
          EXIT SUB
        END IF

        'Doesnt bother checking where the + is
        IF(char == $plus && allow_plus == $$FALSE) THEN
          Log($$LOG_DEBUG, "+ not allowed!")
          EXIT SUB
        END IF

        IF(char == $minus && i != 0) THEN
          Log($$LOG_DEBUG, "minus sign in wrong place!")
          EXIT SUB
        END IF

        IF(char == $decimal) THEN
          IFZ(allow_decimal) THEN
            Log($$LOG_DEBUG, "decimal not allowed!")
            EXIT SUB
          END IF
          IF(i == 0 || i == LEN(temp$) - 1) THEN
            Log($$LOG_DEBUG, "decimal in wrong place!")
            EXIT SUB
          ELSE
            IF(temp${i - 1} < 0x30 || temp${i - 1} > 0x39) THEN
              Log($$LOG_DEBUG, "decimal in wrong place!")
              EXIT SUB
            END IF
          END IF
        END IF

      END IF
    NEXT i

    alpha_ok = $$TRUE
  END SUB
END FUNCTION
'
'
' #########################
' #####  SaveData ()  #####
' #########################
'
FUNCTION  SaveData ()
  SHARED RECORD RecordList[]

  IFZ(#CurrentProject$) THEN RETURN

  IF(#DesignMode) THEN
    SaveLayout(#CurrentLayout$)
  ELSE
    GetDirtyRecords(@#Buff[])
    IF(#Buff[]) THEN
      SaveRecords(@#Buff[])
      REDIM #Buff[]
    END IF
  END IF

END FUNCTION
'
'
' ############################
' #####  ClearFields ()  #####
' ############################
'
FUNCTION  ClearFields ()
   SHARED FIELD FieldList[]

   FOR i = 0 TO UBOUND(FieldList[])
     SELECT CASE FieldList[i].grid_type
        CASE $$ENTRY:
          SELECT CASE FieldList[i].type
           CASE $$FT_STRING_MULTI:
             XuiSendMessage(FieldList[i].grid, #SetTextArray, 0,0,0,0,0, @null$[])
           CASE $$FT_STRING_SINGLE, $$FT_INTEGER, $$FT_REAL:
             XuiSendMessage(FieldList[i].grid, #SetTextString, 0,0,0,0,0, @"")
          END SELECT
        CASE $$IMAGE:
          XuiSendMessage(FieldList[i].grid, #SetTextString,0,0,0,0,0,0)
          XuiSendMessage(FieldList[i].grid, #SetImage, 0,0,0,0,0, @"")
          XgrClearGrid(FieldList[i].grid, $$IMAGE_COLOR)
     END SELECT
     XuiSendMessage(FieldList[i].grid, #RedrawGrid,0,0,0,0,0,0)
   NEXT i
END FUNCTION
'
'
' #######################################
' #####  GetIndexByRecordNumber ()  #####
' #######################################
'
FUNCTION  GetIndexByRecordNumber (record, first, last)
   SHARED FIELD FieldList[]

   fields = UBOUND(FieldList[]) + 1
   last = (fields * (record + 1)) - 1
   first = (last - fields) + 1

END FUNCTION
'
'
' ##############################
' #####  DisplayRecord ()  #####
' ##############################
'
FUNCTION  DisplayRecord (record, update_state)
   SHARED FIELD FieldList[]
   SHARED RECORD RecordList[]
   SHARED StringData$[]
   STATIC XLONG prev_record
   STATIC XLONG update_summary
   $xrRecord = 7
   $xcbMark  = 5
   $xlStatus = 14
   index = 0

  'In Design mode, just show the field name
   IF(#DesignMode) THEN
     FOR i = 0 TO UBOUND(FieldList[])
       XuiSendMessage(FieldList[i].grid, #SetTextArrayLine, 0,0,0,0,0, FieldList[i].name)
       XuiSendMessage(FieldList[i].grid, #SetTextString, 0,0,0,0,0, FieldList[i].name)
       XuiSendMessage(FieldList[i].grid, #RedrawGrid,0,0,0,0,0,0)
     NEXT i
     RETURN
   END IF

   IF(record < 0) THEN
     Log($$LOG_DEBUG, "DisplayRecord() : record id < 0!")
     RETURN
   END IF
   IFZ(RecordList[]) THEN
     Log($$LOG_DEBUG, "DisplayRecord() : Record list is empty!")
     RETURN
   END IF

   first = RecordList[record].first
   last = RecordList[record].last
   FOR i = first TO last
     IF(FieldList[index].in_layout) THEN
       SELECT CASE FieldList[index].type
         CASE $$FT_STRING_MULTI:
           data$ = StringData$[i]
           XstStringToStringArray(@data$, @data$[])
           XuiSendMessage(FieldList[index].grid, #SetTextArray, 0,0,0,0,0, @data$[])
           XuiSendMessage(FieldList[index].grid, #SetTextCursor, 0,0,0,0,0,0)
           XuiSendMessage(FieldList[index].grid, #RedrawText,0,0,0,0,0,0)
         CASE $$FT_STRING_SINGLE, $$FT_INTEGER, $$FT_REAL, $$FT_DATE:
           XuiSendMessage(FieldList[index].grid, #SetTextString, 0,0,0,0,0, StringData$[i])
           XuiSendMessage(FieldList[index].grid, #SetTextCursor, 0,0,0,0,0,0)
           XuiSendMessage(FieldList[index].grid, #RedrawText,0,0,0,0,0,0)
         CASE $$FT_IMAGE:
           SetImage(FieldList[index].grid, index, record, $$FALSE)
         CASE $$FT_SUMMARY:
           'This should only  happen when necessary, not every damn time
           IF(#UpdateSummaryFields) THEN
             Log($$LOG_DEBUG, "Updating summary field " + FieldList[index].name)
             UpdateSummaryField(index)
           END IF
           XuiSendMessage(FieldList[index].grid, #SetTextString, 0,0,0,0,0, StringData$[i])
           XuiSendMessage(FieldList[index].grid, #SetTextCursor, 0,0,0,0,0,0)
           XuiSendMessage(FieldList[index].grid, #RedrawText,0,0,0,0,0,0)
       END SELECT
     END IF
     INC index
   NEXT i

   IF(update_state == $$FALSE) THEN
      RETURN
   END IF

   #CurrentRecord = record
   prev_record = record
   #UpdateSummaryFields = $$FALSE

   XuiSendMessage(#Record, #SetValue, record,0,0,0,$xrRecord, 0)
   XuiSendMessage(#Record, #Redraw, 0,0,0,0,$xrRecord, 0)
   XuiSendMessage(#Record, #GetValues, @a, @b, @c, @d, $xcbMark, @e)
   XuiSendMessage(#Record, #SetValues, RecordList[record].marked, @b, @c, @d, $xcbMark, @e)
   XuiSendMessage(#Record, #Redraw, 0,0,0,0, $xcbMark,0)

   IF(#Timer) THEN XstKillTimer(#Timer) : #Timer = $$FALSE

   IF(RecordList[record].dirty) THEN
      XstStartTimer(@#Timer, 1, 300, &Blink())
   ELSE
      XuiSendMessage(#Record, #GetGridNumber, @grid, 0,0,0, $xlStatus, 0)
      XuiSendMessage(grid, #SetImage, 0,0,0,0,0,0)
      XuiSendMessage(grid, #RedrawGrid, 0,0,0,0,0,0)
   END IF
END FUNCTION
'
'
' ##########################
' #####  AddRecord ()  #####
' ##########################
'
FUNCTION  AddRecord (@record, new, id)
  SHARED StringData$[]
  SHARED FIELD FieldList[]
  SHARED RECORD RecordList[]
  SHARED XLONG RecordOrder[]

  INC #MaxRecord
  #CurrentRecord = #MaxRecord
  record = #CurrentRecord

  IFZ(new) THEN
    rec_id = id
  ELSE
    rec_id = GetNextRecordId()
  END IF
  fields = UBOUND(FieldList[]) + 1

  REDIM StringData$[UBOUND(StringData$[]) + fields]
  REDIM RecordList[UBOUND(RecordList[]) + 1]
  REDIM RecordOrder[UBOUND(RecordOrder[]) + 1]

  GetIndexByRecordNumber(#CurrentRecord, @first, @last)
  index = UBOUND(RecordList[])
  RecordOrder[index] = index
  RecordList[index].first = first
  RecordList[index].last = last
  RecordList[index].new = new
  RecordList[index].id = rec_id
  RecordList[index].dirty = $$FALSE
  RecordList[index].modified = $$FALSE

  FOR i = first TO last
    StringData$[i] = ""
  NEXT i

  XuiSendMessage(#Record, #GetValues, @v0, @v1, @v2, @v3, 7, 0)
  XuiSendMessage(#Record, #SetValues, v0, v1,v2, #MaxRecord + 1, 7, 0)
END FUNCTION
'
'
' ###########################
' #####  SaveRecord ()  #####
' ###########################
'
FUNCTION  SaveRecord (record)
   SHARED FIELD FieldList[]
   SHARED RECORD RecordList[]
   SHARED StringData$[]

   index = 0

   first = RecordList[record].first
   last = RecordList[record].last


   IFZ(UpdateCurrentRecord(record)) THEN
     Log($$LOG_DEBUG, "SaveRecord(): Invalid field data!")
     RETURN $$FALSE
   END IF

   #UpdateSummaryFields = $$TRUE

   IF(RecordList[record].new) THEN
      sql$ = "INSERT INTO " + #TableName$ + " VALUES ("
      sql$ = sql$ + TRIM$(STR$(RecordList[record].id)) + ","
      FOR i = 0 TO UBOUND(FieldList[])
         sql$ = sql$ + "\"" + StringData$[first + i] + "\""
         IF i < UBOUND(FieldList[]) THEN
            sql$ = sql$ + ", "
         ELSE
            sql$ = sql$ + ");"
         END IF
      NEXT i
      RecordList[record].new = $$FALSE
   ELSE
      sql$ = "UPDATE " + #TableName$ + " SET "
      FOR i = 0 TO UBOUND(FieldList[])
         sql$ = sql$ + FieldList[i].name
         sql$ = sql$ + " = \"" + StringData$[first + i] + "\""
         IF i < UBOUND(FieldList[]) THEN
            sql$ = sql$ + ", "
         END IF
      NEXT i
      sql$ = sql$ + " WHERE " + $$SQL_INDEX_COLUMN$ + " = " + TRIM$(STR$(RecordList[record].id)) + ";"
   END IF

   Log($$LOG_INFO, sql$)

   err = 0
   ret = sqlite3_exec(#DB, &sql$, &SQLCallback(), 4, &err)
    IF(ret == 0) THEN
       RecordList[record].dirty = $$FALSE
       RecordList[record].modified = $$FALSE
       RETURN $$TRUE
    ELSE
       err$ = CSTRING$(err)
       ShowMessage(err$)
       RETURN $$FALSE
    END IF
END FUNCTION

'
'
' ############################
' #####  GetFilename ()  #####
' ############################
'
FUNCTION GetFilename (filename$, attributes)
  filename$ = ""
  attributes = $$FALSE
  ret = $$FALSE

  CenterWindow(#File)
  XuiSendMessage(#File, #DisplayWindow, 0,0,0,0,0,0)
  XuiSendMessage(#File, #Redraw, 0,0,0,0,0,0)
  '
  ' Get modal response
  '
   XuiSendMessage ( #File, #SetGridProperties, -1, 0, 0, 0, 0, 0)
   XuiSendMessage ( #File, #GetModalInfo, @v0, @v1, @v2, @v3, @kid, 0)
  IF(v0 == -1) THEN
    filename$ = ""
    ret = $$FALSE
  ELSE
    XuiSendMessage (#File, #GetTextString, 0, 0, 0, 0, 1, @filename$)
  END IF
  XuiSendMessage(#File, #HideWindow, 0,0,0,0,0,0)
  IF filename$ THEN
    XstGetFileAttributes (@filename$, @attributes)
    ret = $$TRUE
  END IF

  RETURN ret

END FUNCTION

'
'
' ####################################
' #####  GetFieldByGrid ()  #####
' ####################################
'
' Check FieldList for grid.  Also check child grids of Fields
'
FUNCTION  GetFieldByGrid (grid, @index)
   SHARED FIELD FieldList[]

   index = -1
   FOR i = 0 TO UBOUND(FieldList[])
      IF(grid == FieldList[i].grid) THEN
         index = i
         RETURN $$TRUE
      ELSE
        DIM kids[]
        XuiGetKidArray(FieldList[i].grid, #GetKidArray, @g, @parent, 0,0,0, @kids[])
        IF(kids[]) THEN
          FOR z = 1 TO UBOUND(kids[])
            IF(grid == kids[z]) THEN
              index = i
              RETURN $$TRUE
            END IF
          NEXT z
        END IF
      END IF
   NEXT i

   RETURN $$FALSE

END FUNCTION
'
'
' ###############################
' #####  CheckFieldName ()  #####
' ###############################
'
' Need the check for valid SQL field name and
' duplicate filed name.
'
FUNCTION  CheckFieldName (name$)
   SHARED FIELD FieldList[]

   IF(name${0} >= 0x30 && name${0} <= 0x39) THEN
       ShowMessage("Field names cannot start with a number!")
      RETURN $$FALSE
    END IF
    FOR i = 0 TO LEN(#IllegalFieldNameChars$)
      IF(INSTR(name$, CHR$(#IllegalFieldNameChars${i}))) THEN
         msg$ = "'" + CHR$(#IllegalFieldNameChars${i}) + "' is not allow in field names!"
         msg$ = msg$ + "\nIllegal characters are: " + #IllegalFieldNameChars$
         ShowMessage(msg$)
         RETURN $$FALSE
      END IF
    NEXT i
   FOR i = 0 TO UBOUND(FieldList[])
      IF(name$ == FieldList[i].name) THEN
             ShowMessage("Field name already exists!")
         RETURN $$FALSE
      END IF
   NEXT i

   RETURN $$TRUE

END FUNCTION
'
'
' ###############################
' #####  GetFieldByName ()  #####
' ###############################
'
FUNCTION  GetFieldByName (name$, index)
   SHARED FIELD FieldList[]

   FOR i = 0 TO UBOUND(FieldList[])
      IF(name$ == FieldList[i].name) THEN
         index = i
         RETURN $$TRUE
      END IF
   NEXT i

   index = -1

   RETURN $$FALSE

END FUNCTION
'
'
' ############################
' #####  SQLCallback ()  #####
' ############################
'
CFUNCTION  SQLCallback (command, argc, argv, columns)
   SHARED StringData$[]

   SELECT CASE command
      CASE $$DB_READ_TABLE: GOSUB ReadTable
      CASE $$DB_READ_DATA:  GOSUB ReadData
      CASE $$DB_DELETE_COLUMN: GOSUB DeleteColumn
   END SELECT

  SUB DeleteColumn
    Log($$LOG_INFO,"Column deleted")
  END SUB

   SUB ReadTable
   'IF(command == $$DB_READ_TABLE) THEN
   '   column$ = CSTRING$(XLONGAT(argv + 4))
   '      IF(column$ != $$SQL_INDEX_COLUMN$) THEN
   '        INC #ColumnCount
   '         'This needs to come from the layout!
   '      g = AddField(column$, $$FT_STRING_SINGLE, 64, $$FALSE, $$FALSE)
   '   END IF
   '    RETURN 0
'   END IF

   END SUB

   SUB ReadData
      data$ = CSTRING$(XLONGAT(argv))
      AddRecord(@record, $$FALSE, XLONG(data$) )
      FOR i = 1 TO argc - 1
         data$ = CSTRING$(XLONGAT(argv + (i * 4)))
        AddRecordData(record, i - 1, @data$)
      NEXT i
      RETURN 0
   END SUB

END FUNCTION
'
'
' #################################
' #####  ReadDatabaseFile ()  #####
' #################################
'
FUNCTION  ReadDatabaseFile (file$)
   IF(#DB == 0) THEN
      ret = sqlite3_open(&file$, &#DB)
      IF(ret <> 0) THEN
         Log($$LOG_ERROR, "Error opening " + file$)
         ShowMessage("Error opening database: " + file$ + "!")
         RETURN $$FALSE
      END IF
   END IF

    db$ = #TableName$ + ".db"

   'This is to retrieve schema, which I no longer need
   'First, read columns
   'query$ = "PRAGMA" + " table_info(" + #TableName$ + ")"
   'err = 0
   'ret = sqlite3_exec(#DB, &query$, &SQLCallback(), $$DB_READ_TABLE, &err)
   ' GOSUB CheckError

   'Now, read data.  This triggers the callback for each row
   Log($$LOG_INFO, "Reading data...")
   query$ = "SELECT * FROM " + #TableName$ + ";"
   err = 0
   ret = sqlite3_exec(#DB, &query$, &SQLCallback(), $$DB_READ_DATA, &err)
   GOSUB CheckError
   Log($$LOG_INFO, "Done.")

   'No data in DB yet.  Create one empty record
   IF(#MaxRecord == -1) THEN
      AddRecord(@record, $$TRUE, 0)
   END IF

   RETURN $$TRUE

   SUB CheckError
      IF(ret <> 0) THEN
        err$ = CSTRING$(err)
        Log($$LOG_ERROR, err$)
        ShowMessage("SQLITE ERROR: " + err$)
        RETURN $$FALSE
      END IF
   END SUB

END FUNCTION
'
'
' ############################
' #####  ReadGeoFile ()  #####
' ############################
'
FUNCTION  ReadGeoFile (file$)
  XstLoadStringArray(file$, @lines$[])
  FOR i = O TO UBOUND(lines$[])
    SELECT CASE TRUE
      CASE lines$[i] == "database":
        #DataFile$ = lines$[i + 1]
      CASE lines$[i] == "table":
        #TableName$ = lines$[i + 1]
    END SELECT
  NEXT i
  IF(LEN(#DataFile$) > 0 && LEN(#TableName$) > 0) THEN
    RETURN $$TRUE
  ELSE
    ShowMessage("There is an error in your .geo file!")
    RETURN $$FALSE
  END IF

   RETURN $$FALSE
END FUNCTION
'
'
' ##############################
' #####  GetNextRecord ()  #####
' ##############################
'
FUNCTION GetNextRecord (@record, option)
   SHARED RECORD RecordList[]
   SHARED XLONG RecordOrder[]
   XLONG rec

   IF(record == #MaxRecord) THEN
     RETURN -1
   END IF

   FOR i = (record + 1) TO UBOUND(RecordList[])
     rec = GetRecord(i)
     SELECT CASE option
       CASE $$GET_MARKED :
         IF(RecordList[rec].marked) THEN
           record = i
           RETURN rec
         END IF
       CASE $$GET_ORDINAL :
         INC record
         RETURN rec
     END SELECT
   NEXT i

   RETURN -1
END FUNCTION
'
'
' ##################################
' #####  GetPreviousRecord ()  #####
' ##################################
'
FUNCTION  GetPreviousRecord (@record, option)
   SHARED RECORD RecordList[]

   IF(record == 0) THEN RETURN -1
   FOR i = (record - 1) TO 0 STEP -1
       rec = GetRecord(i)
     SELECT CASE option
       CASE $$GET_MARKED :
         IF(RecordList[rec].marked) THEN
           record = i
           RETURN rec
         END IF
       CASE $$GET_ORDINAL :
         DEC record
         RETURN rec
     END SELECT
   NEXT i

   RETURN -1

END FUNCTION
'
'
' ###############################
' #####  GetFirstRecord ()  #####
' ###############################
'
FUNCTION  GetFirstRecord (@record, option)
   SHARED RECORD RecordList[]

   record = 0
   FOR i = 0 TO UBOUND(RecordList[])
      rec = GetRecord(i)
     SELECT CASE option
       CASE $$GET_MARKED :
         IF(RecordList[rec].marked) THEN
           record = i
           RETURN rec
         END IF
       CASE $$GET_ORDINAL :
         record = 0
         RETURN rec
     END SELECT
   NEXT i

   RETURN -1

END FUNCTION
'
'
' ##############################
' #####  GetLastRecord ()  #####
' ##############################
'
FUNCTION  GetLastRecord (@record, option)
   SHARED RECORD RecordList[]

   FOR i = #MaxRecord TO 0 STEP -1
     rec = GetRecord(i)
     SELECT CASE option
       CASE $$GET_MARKED :
         IF(RecordList[rec].marked) THEN
           record = i
           RETURN rec
         END IF
       CASE $$GET_ORDINAL :
         record = #MaxRecord
         RETURN rec
     END SELECT
   NEXT i

   RETURN -1
END FUNCTION
'
'
' ##############################
' #####  AddRecordData ()  #####
' ##############################
'
' record = record number
' index = field number
' data$ = string data to add
FUNCTION  AddRecordData (record, index, @data$)
   SHARED RECORD RecordList[]
   SHARED StringData$[]

   IF(record < 0 || record > #MaxRecord) THEN
      RETURN $$FALSE
   END IF

   ptr = RecordList[record].first + index
   StringData$[ptr] = data$
   RETURN $$TRUE
END FUNCTION
'
'
' ##############################
' #####  ResizeRecords ()  #####
' ##############################
'
' This assumes we are only adding records,
' not deleting them!
'
' TODO make this work for add and delete of records
' index is the index of the field that was added or deleted
' first/last are the record size before the field was added/deleted
'
FUNCTION  ResizeRecords (record_size, index, first, last)
   SHARED StringData$[]
   SHARED RECORD RecordList[]
   STATIC old_size

   IF(record_size >= old_size) THEN
      'Getting bigger
      GOSUB Increase
   ELSE
      'Getting smaller
         GOSUB Decrease
   END IF
   old_size = record_size

   RETURN


   '########### SUBS ############
   SUB Decrease
     'Delete of the only remaining record
     'Reset everything
     IF(record_size == -1) THEN
         REDIM StringData$[]
       REDIM RecordList[]
       #MaxRecord = -1
       #FirstField = $$TRUE
       #SelectedGrid = 0
       #CurrentRecord = -1
       SQL_ClearTable()
       RETURN
     END IF
     'Allocate global buffer
     REDIM #Buff$[]
     i = 0
     x = 0
     count = 0
     'Loop through every record
     DO
       FOR z = first TO last
         'Copy only the strings I want to keep
         IF(z != index) THEN
           REDIM #Buff$[x]
           #Buff$[x] = StringData$[i + z]
           INC x
         END IF
       NEXT z
       INC count
       IF(count > #MaxRecord) THEN EXIT DO
       i = i + last + 1
     LOOP
     REDIM StringData$[]
     ATTACH #Buff$[] TO StringData$[]

     GOSUB Resize
   END SUB

   SUB Increase
     'Add 1 * NumRecords new strings
      IFZ(StringData$[]) THEN
        REDIM StringData$[0]
      ELSE
       REDIM StringData$[UBOUND(StringData$[]) + #MaxRecord + 1]
      END IF

     'No copying is needed in this case
     IF(#MaxRecord == 0) THEN
       GOSUB Resize
       EXIT SUB
     END IF

         'Move strings around as needed
      FOR i = #MaxRecord TO 0 STEP -1
         GetIndexByRecordNumber(i, @first, @last)
         StringData$[last] = ""
         x = RecordList[i].last
         FOR z = last - 1 TO first STEP -1
            StringData$[z] = StringData$[x]
          DEC x
        NEXT z
     NEXT i
     GOSUB Resize
   END SUB


   SUB Resize
      FOR i = 0 TO #MaxRecord
       GetIndexByRecordNumber(i, @first, @last)
       RecordList[i].first = first
       RecordList[i].last = last
      NEXT i
    END SUB
END FUNCTION

'	#######################
'	#####  Export ()  #####
'	#######################
'
FUNCTION  Export (grid, message, v0, v1, v2, v3, r0, (r1, r1$, r1[], r1$[]))
	STATIC  designX,  designY,  designWidth,  designHeight
	STATIC  SUBADDR  sub[]
	STATIC  upperMessage
	STATIC  Export
'
	$Export            =   0  ' kid   0 grid type = Export
	$XuiLabel787       =   1  ' kid   1 grid type = XuiLabel
	$xdbExportType     =   2  ' kid   2 grid type = XuiDropBox
	$xrbExportCurrent  =   3  ' kid   3 grid type = XuiRadioBox
	$xrbExportMarked   =   4  ' kid   4 grid type = XuiRadioBox
	$xrbExportAll      =   5  ' kid   5 grid type = XuiRadioBox
	$XuiLabel797       =   6  ' kid   6 grid type = XuiLabel
	$XuiLabel798       =   7  ' kid   7 grid type = XuiLabel
	$XuiLabel799       =   8  ' kid   8 grid type = XuiLabel
	$xpbExport         =   9  ' kid   9 grid type = XuiPushButton
	$xpbCancel         =  10  ' kid  10 grid type = XuiPushButton
	$UpperKid          =  10  ' kid maximum
'
'
	IFZ sub[] THEN GOSUB Initialize
	IF XuiProcessMessage (grid, message, @v0, @v1, @v2, @v3, @r0, @r1, Export) THEN RETURN
	IF (message <= upperMessage) THEN GOSUB @sub[message]
	RETURN
  '
  '
  ' *****  Callback  *****  message = Callback : r1 = original message
  '
  SUB Callback
    message = r1
    callback = message
    IF (message <= upperMessage) THEN GOSUB @sub[message]
  END SUB
  '
  '
  ' *****  Create  *****  v0123 = xywh : r0 = window : r1 = parent
  '
  SUB Create
    IF (v0 <= 0) THEN v0 = 0
    IF (v1 <= 0) THEN v1 = 0
    IF (v2 <= 0) THEN v2 = designWidth
    IF (v3 <= 0) THEN v3 = designHeight
    XuiCreateGrid  (@grid, Export, @v0, @v1, @v2, @v3, r0, r1, &Export())
    XuiSendMessage ( grid, #SetGridName, 0, 0, 0, 0, 0, @"Export")
    XuiLabel       (@g, #Create, 0, 0, 288, 144, r0, grid)
    XuiSendMessage ( g, #SetCallback, grid, &Export(), -1, -1, $XuiLabel787, grid)
    XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"XuiLabel787")
    XuiSendMessage ( g, #SetBorder, $$BorderValley, $$BorderValley, $$BorderNone, 0, 0, 0)
    XuiDropBox     (@g, #Create, 108, 4, 172, 24, r0, grid)
    XuiSendMessage ( g, #SetCallback, grid, &Export(), -1, -1, $xdbExportType, grid)
    XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xdbExportType")
    XuiSendMessage ( g, #SetStyle, 0, 0, 0, 0, 0, 0)
    XuiSendMessage ( g, #SetColor, $$BrightGrey, $$Black, $$Black, $$Green, 0, 0)
    XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"CSV")
    DIM text$[2]
    text$[0] = "CSV"
    text$[1] = "BMP"
    text$[2] = "HTML"
    XuiSendMessage ( g, #SetTextArray, 0, 0, 0, 0, 0, @text$[])
    XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 1, @"TextLine")
    XuiSendMessage ( g, #SetColor, $$White, $$Black, $$Black, $$White, 1, 0)
    XuiSendMessage ( g, #SetBorder, $$BorderLoLine1, $$BorderLoLine1, $$BorderNone, 0, 1, 0)
    XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 1, @"CSV")
    XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 2, @"PressButton")
    XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 3, @"XuiPullDown792")
    XuiSendMessage ( g, #SetColor, $$White, $$Black, $$Black, $$Green, 3, 0)
    XuiSendMessage ( g, #SetColorExtra, $$Grey, $$Green, $$Black, $$White, 3, 0)
    XuiSendMessage ( g, #SetBorder, $$BorderLoLine1, $$BorderLoLine1, $$BorderNone, 0, 3, 0)
    DIM text$[2]
    text$[0] = "CSV"
    text$[1] = "BMP"
    text$[2] = "HTML"
    XuiSendMessage ( g, #SetTextArray, 0, 0, 0, 0, 3, @text$[])
    XuiRadioBox    (@g, #Create, 8, 64, 268, 20, r0, grid)
    XuiSendMessage ( g, #SetCallback, grid, &Export(), -1, -1, $xrbExportCurrent, grid)
    XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xrbExportCurrent")
    XuiSendMessage ( g, #SetStyle, 1, 0, 0, 0, 0, 0)
    XuiSendMessage ( g, #SetBorder, $$BorderNone, $$BorderNone, $$BorderNone, 0, 0, 0)
    XuiSendMessage ( g, #SetTexture, $$TextureNone, 0, 0, 0, 0, 0)
    XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"Current Record")
    XuiRadioBox    (@g, #Create, 8, 84, 268, 20, r0, grid)
    XuiSendMessage ( g, #SetCallback, grid, &Export(), -1, -1, $xrbExportMarked, grid)
    XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xrbExportMarked")
    XuiSendMessage ( g, #SetStyle, 1, 0, 0, 0, 0, 0)
    XuiSendMessage ( g, #SetBorder, $$BorderNone, $$BorderNone, $$BorderNone, 0, 0, 0)
    XuiSendMessage ( g, #SetTexture, $$TextureNone, 0, 0, 0, 0, 0)
    XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"Marked Records")
    XuiRadioBox    (@g, #Create, 8, 104, 268, 20, r0, grid)
    XuiSendMessage ( g, #SetCallback, grid, &Export(), -1, -1, $xrbExportAll, grid)
    XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xrbExportAll")
    XuiSendMessage ( g, #SetStyle, 1, 0, 0, 0, 0, 0)
    XuiSendMessage ( g, #SetBorder, $$BorderNone, $$BorderNone, $$BorderNone, 0, 0, 0)
    XuiSendMessage ( g, #SetTexture, $$TextureNone, 0, 0, 0, 0, 0)
    XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"All Records")
    XuiLabel       (@g, #Create, 4, 4, 96, 24, r0, grid)
    XuiSendMessage ( g, #SetCallback, grid, &Export(), -1, -1, $XuiLabel797, grid)
    XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"XuiLabel797")
    XuiSendMessage ( g, #SetBorder, $$BorderNone, $$BorderNone, $$BorderNone, 0, 0, 0)
    XuiSendMessage ( g, #SetTexture, $$TextureNone, 0, 0, 0, 0, 0)
    XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"Export Type")
    XuiLabel       (@g, #Create, 4, 32, 88, 24, r0, grid)
    XuiSendMessage ( g, #SetCallback, grid, &Export(), -1, -1, $XuiLabel798, grid)
    XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"XuiLabel798")
    XuiSendMessage ( g, #SetAlign, $$AlignMiddleLeft, $$JustifyLeft, -1, -1, 0, 0)
    XuiSendMessage ( g, #SetBorder, $$BorderNone, $$BorderNone, $$BorderNone, 0, 0, 0)
    XuiSendMessage ( g, #SetTexture, $$TextureNone, 0, 0, 0, 0, 0)
    XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"Export:")
    XuiLabel       (@g, #Create, 0, 144, 288, 48, r0, grid)
    XuiSendMessage ( g, #SetCallback, grid, &Export(), -1, -1, $XuiLabel799, grid)
    XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"XuiLabel799")
    XuiSendMessage ( g, #SetBorder, $$BorderValley, $$BorderValley, $$BorderNone, 0, 0, 0)
    XuiPushButton  (@g, #Create, 36, 156, 80, 20, r0, grid)
    XuiSendMessage ( g, #SetCallback, grid, &Export(), -1, -1, $xpbExport, grid)
    XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xpbExport")
    XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"Export")
    XuiPushButton  (@g, #Create, 164, 156, 80, 20, r0, grid)
    XuiSendMessage ( g, #SetCallback, grid, &Export(), -1, -1, $xpbCancel, grid)
    XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xpbCancel")
    XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"Cancel")
    GOSUB Resize
  END SUB
  '
  '
  ' *****  CreateWindow  *****  v0123 = xywh : r0 = windowType : r1$ = display$
  '
  SUB CreateWindow
    IF (v0 == 0) THEN v0 = designX
    IF (v1 == 0) THEN v1 = designY
    IF (v2 <= 0) THEN v2 = designWidth
    IF (v3 <= 0) THEN v3 = designHeight
    XuiWindow (@window, #WindowCreate, v0, v1, v2, v3, r0, @r1$)
    v0 = 0 : v1 = 0 : r0 = window : ATTACH r1$ TO display$
    GOSUB Create
    r1 = 0 : ATTACH display$ TO r1$
    XuiWindow (window, #WindowRegister, grid, -1, v2, v3, @r0, @"Export")
  END SUB
  '
  '
  ' *****  GetSmallestSize  *****  see "Anatomy of Grid Functions"
  '
  SUB GetSmallestSize
  END SUB
  '
  '
  ' *****  Redrawn  *****  see "Anatomy of Grid Functions"
  '
  SUB Redrawn
    XuiCallback (grid, #Redrawn, v0, v1, v2, v3, r0, r1)
  END SUB
  '
  '
  ' *****  Resize  *****  see "Anatomy of Grid Functions"
  '
  SUB Resize
  END SUB
  '
  '
  ' *****  Selection  *****  see "Anatomy of Grid Functions"
  '
  SUB Selection
  END SUB
  '
  '
  ' *****  Initialize  *****  see "Anatomy of Grid Functions"
  '
  SUB Initialize
    XuiGetDefaultMessageFuncArray (@func[])
    XgrMessageNameToNumber (@"LastMessage", @upperMessage)
  '
    func[#Callback]           = &XuiCallback ()               ' disable to handle Callback messages internally
  ' func[#GetSmallestSize]    = 0                             ' enable to add internal GetSmallestSize routine
  ' func[#Resize]             = 0                             ' enable to add internal Resize routine
  '
    DIM sub[upperMessage]
  '	sub[#Callback]            = SUBADDRESS (Callback)         ' enable to handle Callback messages internally
    sub[#Create]              = SUBADDRESS (Create)           ' must be subroutine in this function
    sub[#CreateWindow]        = SUBADDRESS (CreateWindow)     ' must be subroutine in this function
  '	sub[#GetSmallestSize]     = SUBADDRESS (GetSmallestSize)  ' enable to add internal GetSmallestSize routine
    sub[#Redrawn]             = SUBADDRESS (Redrawn)          ' generate #Redrawn callback if appropriate
  '	sub[#Resize]              = SUBADDRESS (Resize)           ' enable to add internal Resize routine
    sub[#Selection]           = SUBADDRESS (Selection)        ' routes Selection callbacks to subroutine
  '
    IF sub[0] THEN PRINT "Export() : Initialize : error ::: (undefined message)"
    IF func[0] THEN PRINT "Export() : Initialize : error ::: (undefined message)"
    XuiRegisterGridType (@Export, "Export", &Export(), @func[], @sub[])
  '
  ' Don't remove the following 4 lines, or WindowFromFunction/WindowToFunction will not work
  '
    designX = 525
    designY = 136
    designWidth = 288
    designHeight = 192
  '
    gridType = Export
    XuiSetGridTypeProperty (gridType, @"x",                designX)
    XuiSetGridTypeProperty (gridType, @"y",                designY)
    XuiSetGridTypeProperty (gridType, @"width",            designWidth)
    XuiSetGridTypeProperty (gridType, @"height",           designHeight)
    XuiSetGridTypeProperty (gridType, @"maxWidth",         designWidth)
    XuiSetGridTypeProperty (gridType, @"maxHeight",        designHeight)
    XuiSetGridTypeProperty (gridType, @"minWidth",         designWidth)
    XuiSetGridTypeProperty (gridType, @"minHeight",        designHeight)
    XuiSetGridTypeProperty (gridType, @"can",              $$Focus OR $$Respond OR $$Callback OR $$TextSelection)
    XuiSetGridTypeProperty (gridType, @"focusKid",         $xdbExportType)
    XuiSetGridTypeProperty (gridType, @"inputTextString",  $xdbExportType)
    IFZ message THEN RETURN
  END SUB
END FUNCTION

' ###########################
' #####  ExportCode ()  #####
' ###########################
'
FUNCTION  ExportCode (grid, message, v0, v1, v2, v3, kid, r1)
  STATIC XLONG type
  $Export            =   0  ' kid   0 grid type = Export
  $XuiLabel787       =   1  ' kid   1 grid type = XuiLabel
  $xdbExportType     =   2  ' kid   2 grid type = XuiDropBox
  $xrbExportCurrent  =   3  ' kid   3 grid type = XuiRadioBox
  $xrbExportMarked   =   4  ' kid   4 grid type = XuiRadioBox
  $xrbExportAll      =   5  ' kid   5 grid type = XuiRadioBox
  $XuiLabel797       =   6  ' kid   6 grid type = XuiLabel
  $XuiLabel798       =   7  ' kid   7 grid type = XuiLabel
  $XuiLabel799       =   8  ' kid   8 grid type = XuiLabel
  $xpbExport         =   9  ' kid   9 grid type = XuiPushButton
  $xpbCancel         =  10  ' kid  10 grid type = XuiPushButton
  $UpperKid          =  10  ' kid maximum

  IF (message == #Callback) THEN message = r1

  SELECT CASE message
    CASE #Selection		: GOSUB Selection   	' most common callback message
    CASE #CloseWindow	: GOSUB CloseWindow
  END SELECT
  RETURN

  SUB Selection
    SELECT CASE kid
      CASE $xdbExportType     :
      CASE $xrbExportCurrent  : type = $$EXPORT_CURRENT
      CASE $xrbExportMarked   : type = $$EXPORT_MARKED
      CASE $xrbExportAll      : type = $$EXPORT_ALL
      CASE $xpbExport         : GOSUB StartExport
      CASE $xpbCancel         : GOSUB CloseWindow
    END SELECT
  END SUB

  SUB CloseWindow
    XuiSendMessage(#Record, #ShowWindow,0,0,0,0,0,0)
    XuiSendMessage(#Export, #HideWindow, 0,0,0,0,0,0)
  END SUB

  SUB StartExport
    IF(type == 0) THEN
      ShowMessage("Select records to export!")
      EXIT SUB
    END IF
    'Sometimes, #Record doesn't like to hide. Tell him twice
    XuiSendMessage(#Record, #HideWindow,0,0,0,0,0,0)
    XuiSendMessage(#Record, #HideWindow,0,0,0,0,0,0)
    XuiSendMessage(#Export, #HideWindow,0,0,0,0,0,0)
    XuiSendMessage(#Export, #GetTextString, 0,0,0,0, $xdbExportType, @line$)
    SELECT CASE line$
      CASE "CSV"  : GOSUB ExportCSV
      CASE "BMP"  : GOSUB ExportBMP
      CASE "HTML" : GOSUB ExportHTML
    END SELECT
    XstSleep(1000)
    #PrintActive = $$FALSE
    GOSUB CloseWindow
  END SUB

  SUB ExportBMP
    #PrintActive = $$TRUE
    ExportRecords("", $$EXPORT_BMP, type)
  END SUB

  SUB ExportCSV
    GetFilename(@file$, @attr)
    IF(file$) THEN ExportRecords(@file$, $$EXPORT_CSV, type)
  END SUB

  SUB ExportHTML
    GetFilename(@file$, @attr)
    IF(file$) THEN ExportRecords(@file$, $$EXPORT_HTML, type)
  END SUB

END FUNCTION

'  ############################
'  #####  MarkRecords ()  #####
'  ############################
'
FUNCTION  MarkRecords (grid, message, v0, v1, v2, v3, r0, (r1, r1$, r1[], r1$[]))
   STATIC  designX,  designY,  designWidth,  designHeight
   STATIC  SUBADDR  sub[]
   STATIC  upperMessage
   STATIC  MarkRecords
'
   $MarkRecords      =   0  ' kid   0 grid type = MarkRecords
   $XuiLabel754      =   1  ' kid   1 grid type = XuiLabel
   $XuiLabel755      =   2  ' kid   2 grid type = XuiLabel
   $xpbMark          =   3  ' kid   3 grid type = XuiPushButton
   $xpbCancel        =   4  ' kid   4 grid type = XuiPushButton
   $xpbHelp          =   5  ' kid   5 grid type = XuiPushButton
   $XuiLabel759      =   6  ' kid   6 grid type = XuiLabel
   $xlFieldList      =   7  ' kid   7 grid type = XuiList
   $xcbIgnoreCase    =   8  ' kid   8 grid type = XuiCheckBox
   $xcbMatchAtStart  =   9  ' kid   9 grid type = XuiCheckBox
   $XuiTextLine766   =  10  ' kid  10 grid type = XuiTextLine
   $XuiLabel768      =  11  ' kid  11 grid type = XuiLabel
   $xlSelectedField  =  12  ' kid  12 grid type = XuiLabel
   $UpperKid         =  12  ' kid maximum
'
'
   IFZ sub[] THEN GOSUB Initialize
   IF XuiProcessMessage (grid, message, @v0, @v1, @v2, @v3, @r0, @r1, MarkRecords) THEN RETURN
   IF (message <= upperMessage) THEN GOSUB @sub[message]
   RETURN

  SUB Callback
     message = r1
     callback = message
     IF (message <= upperMessage) THEN GOSUB @sub[message]
  END SUB

  SUB Create
     IF (v0 <= 0) THEN v0 = 0
     IF (v1 <= 0) THEN v1 = 0
     IF (v2 <= 0) THEN v2 = designWidth
     IF (v3 <= 0) THEN v3 = designHeight
     XuiCreateGrid  (@grid, MarkRecords, @v0, @v1, @v2, @v3, r0, r1, &MarkRecords())
     XuiSendMessage ( grid, #SetGridName, 0, 0, 0, 0, 0, @"MarkRecords")
     XuiLabel       (@g, #Create, 4, 4, 152, 16, r0, grid)
     XuiSendMessage ( g, #SetCallback, grid, &MarkRecords(), -1, -1, $XuiLabel754, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"XuiLabel754")
     XuiSendMessage ( g, #SetBorder, $$BorderNone, $$BorderNone, $$BorderNone, 0, 0, 0)
     XuiSendMessage ( g, #SetTexture, $$TextureNone, 0, 0, 0, 0, 0)
     XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"Select Mark Field:")
     XuiLabel       (@g, #Create, 4, 260, 236, 44, r0, grid)
     XuiSendMessage ( g, #SetCallback, grid, &MarkRecords(), -1, -1, $XuiLabel755, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"XuiLabel755")
     XuiSendMessage ( g, #SetBorder, $$BorderValley, $$BorderValley, $$BorderNone, 0, 0, 0)
     XuiPushButton  (@g, #Create, 12, 272, 64, 20, r0, grid)
     XuiSendMessage ( g, #SetCallback, grid, &MarkRecords(), -1, -1, $xpbMark, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xpbMark")
     XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"Mark")
     XuiPushButton  (@g, #Create, 88, 272, 64, 20, r0, grid)
     XuiSendMessage ( g, #SetCallback, grid, &MarkRecords(), -1, -1, $xpbCancel, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xpbCancel")
     XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"Cancel")
     XuiPushButton  (@g, #Create, 164, 272, 64, 20, r0, grid)
     XuiSendMessage ( g, #SetCallback, grid, &MarkRecords(), -1, -1, $xpbHelp, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xpbHelp")
     XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"?")
     XuiLabel       (@g, #Create, 4, 20, 236, 240, r0, grid)
     XuiSendMessage ( g, #SetCallback, grid, &MarkRecords(), -1, -1, $XuiLabel759, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"XuiLabel759")
     XuiSendMessage ( g, #SetBorder, $$BorderValley, $$BorderValley, $$BorderNone, 0, 0, 0)
     XuiList        (@g, #Create, 8, 24, 228, 132, r0, grid)
     XuiSendMessage ( g, #SetCallback, grid, &MarkRecords(), -1, -1, $xlFieldList, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xlFieldList")
     XuiSendMessage ( g, #SetStyle, 0, 0, 0, 0, 0, 0)
     XuiSendMessage ( g, #SetBorder, $$BorderLower1, $$BorderLower1, $$BorderNone, 0, 0, 0)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 1, @"List")
     XuiSendMessage ( g, #SetColor, $$White, $$Black, $$Black, $$White, 1, 0)
     XuiSendMessage ( g, #SetColorExtra, $$Grey, $$BrightGreen, $$Black, $$White, 1, 0)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 2, @"ScrollH")
     XuiSendMessage ( g, #SetStyle, 2, 0, 0, 0, 2, 0)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 3, @"ScrollV")
     XuiSendMessage ( g, #SetStyle, 2, 0, 0, 0, 3, 0)
     XuiCheckBox    (@g, #Create, 8, 180, 228, 16, r0, grid)
     XuiSendMessage ( g, #SetCallback, grid, &MarkRecords(), -1, -1, $xcbIgnoreCase, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xcbIgnoreCase")
     XuiSendMessage ( g, #SetStyle, 2, 3, 0, 0, 0, 0)
     XuiSendMessage ( g, #SetBorder, $$BorderNone, $$BorderNone, $$BorderRaise1, 0, 0, 0)
     XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"Ignore Case")
     XuiCheckBox    (@g, #Create, 8, 196, 228, 16, r0, grid)
     XuiSendMessage ( g, #SetCallback, grid, &MarkRecords(), -1, -1, $xcbMatchAtStart, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xcbMatchAtStart")
     XuiSendMessage ( g, #SetStyle, 2, 3, 0, 0, 0, 0)
     XuiSendMessage ( g, #SetBorder, $$BorderNone, $$BorderNone, $$BorderRaise1, 0, 0, 0)
     XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"Match Partial Words")
     XuiTextLine    (@g, #Create, 8, 236, 228, 20, r0, grid)
     XuiSendMessage ( g, #SetCallback, grid, &MarkRecords(), -1, -1, $XuiTextLine766, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"XuiTextLine766")
     XuiSendMessage ( g, #SetColor, $$White, $$Black, $$Black, $$White, 0, 0)
     XuiSendMessage ( g, #SetBorder, $$BorderLower1, $$BorderLower1, $$BorderNone, 0, 0, 0)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 1, @"XuiArea767")
     XuiSendMessage ( g, #SetColor, $$White, $$Black, $$Black, $$White, 1, 0)
     XuiLabel       (@g, #Create, 8, 216, 228, 20, r0, grid)
     XuiSendMessage ( g, #SetCallback, grid, &MarkRecords(), -1, -1, $XuiLabel768, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"XuiLabel768")
     XuiSendMessage ( g, #SetBorder, $$BorderNone, $$BorderNone, $$BorderNone, 0, 0, 0)
     XuiSendMessage ( g, #SetTexture, $$TextureNone, 0, 0, 0, 0, 0)
     XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"Text To Match:")
     XuiLabel       (@g, #Create, 8, 157, 228, 20, r0, grid)
     XuiSendMessage ( g, #SetCallback, grid, &MarkRecords(), -1, -1, $xlSelectedField, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xlSelectedField")
     XuiSendMessage ( g, #SetBorder, $$BorderValley, $$BorderValley, $$BorderNone, 0, 0, 0)
     XuiSendMessage ( g, #SetTexture, $$TextureNone, 0, 0, 0, 0, 0)
     GOSUB Resize
  END SUB

  SUB CreateWindow
     IF (v0 == 0) THEN v0 = designX
     IF (v1 == 0) THEN v1 = designY
     IF (v2 <= 0) THEN v2 = designWidth
     IF (v3 <= 0) THEN v3 = designHeight
     XuiWindow (@window, #WindowCreate, v0, v1, v2, v3, r0, @r1$)
     v0 = 0 : v1 = 0 : r0 = window : ATTACH r1$ TO display$
     GOSUB Create
     r1 = 0 : ATTACH display$ TO r1$
     XuiWindow (window, #WindowRegister, grid, -1, v2, v3, @r0, @"MarkRecords")
  END SUB

  SUB GetSmallestSize
  END SUB

  SUB Redrawn
     XuiCallback (grid, #Redrawn, v0, v1, v2, v3, r0, r1)
  END SUB

  SUB Resize
  END SUB

  SUB Selection
  END SUB

  SUB Initialize
     XuiGetDefaultMessageFuncArray (@func[])
     XgrMessageNameToNumber (@"LastMessage", @upperMessage)
  '
     func[#Callback]           = &XuiCallback ()               ' disable to handle Callback messages internally
  ' func[#GetSmallestSize]    = 0                             ' enable to add internal GetSmallestSize routine
  ' func[#Resize]             = 0                             ' enable to add internal Resize routine
  '
     DIM sub[upperMessage]
  '  sub[#Callback]            = SUBADDRESS (Callback)         ' enable to handle Callback messages internally
     sub[#Create]              = SUBADDRESS (Create)           ' must be subroutine in this function
     sub[#CreateWindow]        = SUBADDRESS (CreateWindow)     ' must be subroutine in this function
  '  sub[#GetSmallestSize]     = SUBADDRESS (GetSmallestSize)  ' enable to add internal GetSmallestSize routine
     sub[#Redrawn]             = SUBADDRESS (Redrawn)          ' generate #Redrawn callback if appropriate
  '  sub[#Resize]              = SUBADDRESS (Resize)           ' enable to add internal Resize routine
     sub[#Selection]           = SUBADDRESS (Selection)        ' routes Selection callbacks to subroutine
  '
     IF sub[0] THEN PRINT "MarkRecords() : Initialize : error ::: (undefined message)"
     IF func[0] THEN PRINT "MarkRecords() : Initialize : error ::: (undefined message)"
     XuiRegisterGridType (@MarkRecords, "MarkRecords", &MarkRecords(), @func[], @sub[])
  '
  ' Don't remove the following 4 lines, or WindowFromFunction/WindowToFunction will not work
  '
     designX = 567
     designY = 117
     designWidth = 244
     designHeight = 312
  '
     gridType = MarkRecords
     XuiSetGridTypeProperty (gridType, @"x",                designX)
     XuiSetGridTypeProperty (gridType, @"y",                designY)
     XuiSetGridTypeProperty (gridType, @"width",            designWidth)
     XuiSetGridTypeProperty (gridType, @"height",           designHeight)
     XuiSetGridTypeProperty (gridType, @"maxWidth",         designWidth)
     XuiSetGridTypeProperty (gridType, @"maxHeight",        designHeight)
     XuiSetGridTypeProperty (gridType, @"minWidth",         designWidth)
     XuiSetGridTypeProperty (gridType, @"minHeight",        designHeight)
     XuiSetGridTypeProperty (gridType, @"can",              $$Focus OR $$Respond OR $$Callback OR $$TextSelection)
     XuiSetGridTypeProperty (gridType, @"focusKid",         $xpbMark)
     XuiSetGridTypeProperty (gridType, @"inputTextString",  $XuiTextLine766)
     IFZ message THEN RETURN
  END SUB
END FUNCTION

' ################################
' #####  MarkRecordsCode ()  #####
' ################################
'
FUNCTION  MarkRecordsCode (grid, message, v0, v1, v2, v3, kid, r1)
  STATIC XLONG ignore
  STATIC XLONG partial
  STATIC XLONG field

   $MarkRecords      =   0  ' kid   0 grid type = MarkRecords
   $XuiLabel754      =   1  ' kid   1 grid type = XuiLabel
   $XuiLabel755      =   2  ' kid   2 grid type = XuiLabel
   $xpbMark          =   3  ' kid   3 grid type = XuiPushButton
   $xpbCancel        =   4  ' kid   4 grid type = XuiPushButton
   $xpbHelp          =   5  ' kid   5 grid type = XuiPushButton
   $XuiLabel759      =   6  ' kid   6 grid type = XuiLabel
   $xlFieldList      =   7  ' kid   7 grid type = XuiList
   $xcbIgnoreCase    =   8  ' kid   8 grid type = XuiCheckBox
   $xcbMatchAtStart  =   9  ' kid   9 grid type = XuiCheckBox
   $XuiTextLine766   =  10  ' kid  10 grid type = XuiTextLine
   $XuiLabel768      =  11  ' kid  11 grid type = XuiLabel
   $xlSelectedField  =  12  ' kid  12 grid type = XuiLabel
   $UpperKid         =  12  ' kid maximum

   IF (message == #Callback) THEN message = r1
'
   SELECT CASE message
      CASE #Notify         : GOSUB RepopulateFieldList
      CASE #Selection      : GOSUB Selection
      CASE #CloseWindow : XuiSendMessage (grid, #HideWindow, 0, 0, 0, 0, 0, 0)
   END SELECT
   RETURN

  SUB Selection
     SELECT CASE kid
        CASE $xpbMark          : GOSUB MarkRecords
        CASE $xpbCancel        : XuiSendMessage(grid, #HideWindow, 0,0,0,0,0,0)
        CASE $xpbHelp          : Help()
        CASE $xlFieldList      : GOSUB SetSelectedField
        CASE $xcbIgnoreCase    : ignore = v0
        CASE $xcbMatchAtStart  : partial = v0
        CASE $XuiTextLine766   : GOSUB MarkRecords
     END SELECT
  END SUB

  SUB MarkRecords
     XuiSendMessage(grid, #GetTextString, 0,0,0,0, $XuiTextLine766, @line$)

    'IFZ(line$) THEN EXIT SUB

    'Unmark all records first.
    GetMarkedRecords(@#Buff[])
    FOR i = 0 TO UBOUND(#Buff[])
      MarkRecord(#Buff[i], $$FALSE)
    NEXT i

    record = GetOrderIndex(#CurrentRecord)
    count = 0
    record = 0
    DO
      rec = FindRecordByString(line$, @record, $$FindForward, partial, ignore, field, $$GET_ORDINAL, $$TRUE)
      IF(rec >= 0) THEN
        MarkRecord(rec, $$TRUE)
        DisplayRecord(rec, $$TRUE)
        INC count
      END IF
      INC record
    LOOP WHILE record <= #MaxRecord
    Log($$LOG_INFO, STR$(count) + " records marked")
    IF(count == 0) THEN
      ShowMessage("No Records Found!")
    END IF
  END SUB

  SUB SetSelectedField
    field = v0
     XuiSendMessage(grid, #GetTextArrayLine, v0, 0,0,0, $xlFieldList, @line$)
    XuiSendMessage(grid, #SetTextString, 0,0,0,0, $xlSelectedField, @line$)
    XuiSendMessage(grid, #Redraw, 0,0,0,0, $xlSelectedField, 0)
  END SUB

  SUB ClearSelectedField
    XuiSendMessage(grid, #SetTextString, 0,0,0,0, $xlSelectedField, @"")
    XuiSendMessage(grid, #Redraw, 0,0,0,0, $xlSelectedField, 0)
  END SUB

  SUB RepopulateFieldList
     GetFieldNames(@names$[])
     XuiSendMessage(grid, #SetTextArray, 0,0,0,0, $xlFieldList, @names$[])
     XuiSendMessage(grid, #RedrawText, 0,0,0,0, $xlFieldList, 0)
  END SUB

END FUNCTION

' ###################################
' #####  FindRecordByString ()  #####
' ###################################
'
'
FUNCTION  FindRecordByString (data$, @record, direction, partial, ignore, field, opt, include)
   SHARED RECORD RecordList[]
   SHARED StringData$[]
   XLONG rec

   IF(ignore) THEN data$ = LCASE$(data$)
   'Include current record in search
   IF(include) THEN
     rec = GetRecord(record)
     IF(field >= 0) THEN
       GOSUB SearchField
     ELSE
       GOSUB SearchRecord
     END IF
   END IF
   IF(direction == $$FindForward) THEN
      rec = GetNextRecord(@record, opt)
      DO WHILE (rec != -1)
         IF(field >= 0) THEN
           GOSUB SearchField
         ELSE
           GOSUB SearchRecord
         END IF
         rec = GetNextRecord(@record, opt)
      LOOP
   ELSE
      rec = GetPreviousRecord(@record, opt)
      DO WHILE (rec != -1)
         IF(field >= 0) THEN
           GOSUB SearchField
         ELSE
           GOSUB SearchRecord
         END IF
         rec = GetPreviousRecord(@record, opt)
      LOOP
   END IF

   RETURN -1

   SUB SearchField
     string$ = StringData$[RecordList[rec].first + field]
     GOSUB Search
   END SUB

   SUB SearchRecord
      FOR z = RecordList[rec].first TO RecordList[rec].last
         string$ = StringData$[z]
         GOSUB Search
      NEXT z
   END SUB

   SUB Search
     IF(ignore) THEN
       string$ = LCASE$(string$)
     END IF
     IF(partial) THEN
       IF(INSTR(string$, data$)) THEN
         RETURN rec
       END IF
     ELSE
       Tokenize(@string$, @#Buff$[], $$DELIMITERS$)
       FOR i = 0 TO UBOUND(#Buff$[])
         IF(#Buff$[i] == data$) THEN
           RETURN rec
         END IF
       NEXT i
     END IF
   END SUB
END FUNCTION

'  #####################
'  #####  Find ()  #####
'  #####################
'
FUNCTION  Find (grid, message, v0, v1, v2, v3, r0, (r1, r1$, r1[], r1$[]))
   STATIC  designX,  designY,  designWidth,  designHeight
   STATIC  SUBADDR  sub[]
   STATIC  upperMessage
   STATIC  Find
'
   $Find             =   0  ' kid   0 grid type = Find
   $XuiLabel805      =   1  ' kid   1 grid type = XuiLabel
   $xtlFindString    =   2  ' kid   2 grid type = XuiTextLine
   $XuiLabel808      =   3  ' kid   3 grid type = XuiLabel
   $xcbIgnoreCase    =   4  ' kid   4 grid type = XuiCheckBox
   $xcbMatchPartial  =   5  ' kid   5 grid type = XuiCheckBox
   $xpbFindNext      =   6  ' kid   6 grid type = XuiPushButton
   $xpbPrevious      =   7  ' kid   7 grid type = XuiPushButton
   $xpbClose         =   8  ' kid   8 grid type = XuiPushButton
   $UpperKid         =   8  ' kid maximum

   IFZ sub[] THEN GOSUB Initialize
   IF XuiProcessMessage (grid, message, @v0, @v1, @v2, @v3, @r0, @r1, Find) THEN RETURN
   IF (message <= upperMessage) THEN GOSUB @sub[message]
   RETURN

  SUB Callback
     message = r1
     callback = message
     IF (message <= upperMessage) THEN GOSUB @sub[message]
  END SUB

  SUB Create
     IF (v0 <= 0) THEN v0 = 0
     IF (v1 <= 0) THEN v1 = 0
     IF (v2 <= 0) THEN v2 = designWidth
     IF (v3 <= 0) THEN v3 = designHeight
     XuiCreateGrid  (@grid, Find, @v0, @v1, @v2, @v3, r0, r1, &Find())
     XuiSendMessage ( grid, #SetGridName, 0, 0, 0, 0, 0, @"Find")
     XuiLabel       (@g, #Create, 8, 4, 48, 20, r0, grid)
     XuiSendMessage ( g, #SetCallback, grid, &Find(), -1, -1, $XuiLabel805, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"XuiLabel805")
     XuiSendMessage ( g, #SetBorder, $$BorderNone, $$BorderNone, $$BorderNone, 0, 0, 0)
     XuiSendMessage ( g, #SetTexture, $$TextureNone, 0, 0, 0, 0, 0)
     XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"Find:")
     XuiTextLine    (@g, #Create, 60, 4, 308, 20, r0, grid)
     XuiSendMessage ( g, #SetCallback, grid, &Find(), -1, -1, $xtlFindString, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xtlFindString")
     XuiSendMessage ( g, #SetColor, $$White, $$Black, $$Black, $$White, 0, 0)
     XuiSendMessage ( g, #SetBorder, $$BorderLower1, $$BorderLower1, $$BorderNone, 0, 0, 0)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 1, @"XuiArea807")
     XuiSendMessage ( g, #SetColor, $$White, $$Black, $$Black, $$White, 1, 0)
     XuiLabel       (@g, #Create, 4, 48, 368, 32, r0, grid)
     XuiSendMessage ( g, #SetCallback, grid, &Find(), -1, -1, $XuiLabel808, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"XuiLabel808")
     XuiSendMessage ( g, #SetBorder, $$BorderValley, $$BorderValley, $$BorderNone, 0, 0, 0)
     XuiCheckBox    (@g, #Create, 4, 28, 152, 16, r0, grid)
     XuiSendMessage ( g, #SetCallback, grid, &Find(), -1, -1, $xcbIgnoreCase, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xcbIgnoreCase")
     XuiSendMessage ( g, #SetStyle, 2, 3, 0, 0, 0, 0)
     XuiSendMessage ( g, #SetBorder, $$BorderNone, $$BorderNone, $$BorderRaise1, 0, 0, 0)
     XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"Ignore Case")
     XuiCheckBox    (@g, #Create, 176, 28, 188, 16, r0, grid)
     XuiSendMessage ( g, #SetCallback, grid, &Find(), -1, -1, $xcbMatchPartial, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xcbMatchPartial")
     XuiSendMessage ( g, #SetStyle, 2, 3, 0, 0, 0, 0)
     XuiSendMessage ( g, #SetBorder, $$BorderNone, $$BorderNone, $$BorderRaise1, 0, 0, 0)
     XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"Match Partial Words")
     XuiPushButton  (@g, #Create, 20, 56, 64, 16, r0, grid)
     XuiSendMessage ( g, #SetCallback, grid, &Find(), -1, -1, $xpbFindNext, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xpbFindNext")
     XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"Next")
     XuiPushButton  (@g, #Create, 152, 56, 68, 16, r0, grid)
     XuiSendMessage ( g, #SetCallback, grid, &Find(), -1, -1, $xpbPrevious, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xpbPrevious")
     XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"Previous")
     XuiPushButton  (@g, #Create, 284, 56, 64, 16, r0, grid)
     XuiSendMessage ( g, #SetCallback, grid, &Find(), -1, -1, $xpbClose, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xpbClose")
     XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"Close")
     GOSUB Resize
  END SUB

  SUB CreateWindow
     IF (v0 == 0) THEN v0 = designX
     IF (v1 == 0) THEN v1 = designY
     IF (v2 <= 0) THEN v2 = designWidth
     IF (v3 <= 0) THEN v3 = designHeight
     XuiWindow (@window, #WindowCreate, v0, v1, v2, v3, r0, @r1$)
     v0 = 0 : v1 = 0 : r0 = window : ATTACH r1$ TO display$
     GOSUB Create
     r1 = 0 : ATTACH display$ TO r1$
     XuiWindow (window, #WindowRegister, grid, -1, v2, v3, @r0, @"Find")
  END SUB

  SUB GetSmallestSize
  END SUB

  SUB Redrawn
     XuiCallback (grid, #Redrawn, v0, v1, v2, v3, r0, r1)
  END SUB

  SUB Resize
  END SUB

  SUB Selection
  END SUB

  SUB Initialize
     XuiGetDefaultMessageFuncArray (@func[])
     XgrMessageNameToNumber (@"LastMessage", @upperMessage)
  '
     func[#Callback]           = &XuiCallback ()               ' disable to handle Callback messages internally
  ' func[#GetSmallestSize]    = 0                             ' enable to add internal GetSmallestSize routine
  ' func[#Resize]             = 0                             ' enable to add internal Resize routine
  '
     DIM sub[upperMessage]
  '  sub[#Callback]            = SUBADDRESS (Callback)         ' enable to handle Callback messages internally
     sub[#Create]              = SUBADDRESS (Create)           ' must be subroutine in this function
     sub[#CreateWindow]        = SUBADDRESS (CreateWindow)     ' must be subroutine in this function
  '  sub[#GetSmallestSize]     = SUBADDRESS (GetSmallestSize)  ' enable to add internal GetSmallestSize routine
     sub[#Redrawn]             = SUBADDRESS (Redrawn)          ' generate #Redrawn callback if appropriate
  '  sub[#Resize]              = SUBADDRESS (Resize)           ' enable to add internal Resize routine
     sub[#Selection]           = SUBADDRESS (Selection)        ' routes Selection callbacks to subroutine
  '
     IF sub[0] THEN PRINT "Find() : Initialize : error ::: (undefined message)"
     IF func[0] THEN PRINT "Find() : Initialize : error ::: (undefined message)"
     XuiRegisterGridType (@Find, "Find", &Find(), @func[], @sub[])

     designX = 383
     designY = 232
     designWidth = 376
     designHeight = 84
  '
     gridType = Find
     XuiSetGridTypeProperty (gridType, @"x",                designX)
     XuiSetGridTypeProperty (gridType, @"y",                designY)
     XuiSetGridTypeProperty (gridType, @"width",            designWidth)
     XuiSetGridTypeProperty (gridType, @"height",           designHeight)
     XuiSetGridTypeProperty (gridType, @"maxWidth",         designWidth)
     XuiSetGridTypeProperty (gridType, @"maxHeight",        designHeight)
     XuiSetGridTypeProperty (gridType, @"minWidth",         designWidth)
     XuiSetGridTypeProperty (gridType, @"minHeight",        designHeight)
     XuiSetGridTypeProperty (gridType, @"can",              $$Focus OR $$Respond OR $$Callback OR $$TextSelection)
     XuiSetGridTypeProperty (gridType, @"focusKid",         $xtlFindString)
     XuiSetGridTypeProperty (gridType, @"inputTextString",  $xtlFindString)
     IFZ message THEN RETURN
  END SUB
END FUNCTION

' #########################
' #####  FindCode ()  #####
' #########################
'
FUNCTION  FindCode (grid, message, v0, v1, v2, v3, kid, r1)
   XLONG direction
   STATIC XLONG ignore
   STATIC XLONG partial

   $Find             =   0  ' kid   0 grid type = Find
   $XuiLabel805      =   1  ' kid   1 grid type = XuiLabel
   $xtlFindString    =   2  ' kid   2 grid type = XuiTextLine
   $XuiLabel808      =   3  ' kid   3 grid type = XuiLabel
   $xcbIgnoreCase    =   4  ' kid   4 grid type = XuiCheckBox
   $xcbMatchPartial  =   5  ' kid   5 grid type = XuiCheckBox
   $xpbFindNext      =   6  ' kid   6 grid type = XuiPushButton
   $xpbPrevious      =   7  ' kid   7 grid type = XuiPushButton
   $xpbClose         =   8  ' kid   8 grid type = XuiPushButton
   $UpperKid         =   8  ' kid maximum

   IF (message == #Callback) THEN message = r1
'
   SELECT CASE message
      CASE #Selection      : GOSUB Selection
      CASE #CloseWindow : XuiSendMessage (grid, #HideWindow, 0, 0, 0, 0, 0, 0)
   END SELECT
   RETURN

  SUB Selection
     SELECT CASE kid
        CASE $Find             :
        CASE $XuiLabel805      :
        CASE $xtlFindString    :
        CASE $XuiLabel808      :
        CASE $xcbIgnoreCase    :ignore = v0
        CASE $xcbMatchPartial  :partial = v0
        CASE $xpbFindNext      :GOSUB xpbFindNext_Clicked
        CASE $xpbPrevious      :GOSUB xpbFindPrevious_Clicked
        CASE $xpbClose         :XuiSendMessage(#Find, #HideWindow, 0,0,0,0,0,0)
     END SELECT
  END SUB

   SUB xpbFindNext_Clicked
      direction = $$FindForward
      GOSUB Find
   END SUB

   SUB xpbFindPrevious_Clicked
      direction = $$FindReverse
      GOSUB Find
   END SUB

   SUB Find
      record = GetOrderIndex(#CurrentRecord)
      XuiSendMessage(grid, #GetTextString, 0,0,0,0, $xtlFindString, @text$)

      rec = FindRecordByString(text$, @record, direction, partial, ignore, -1, $$GET_ORDINAL, $$FALSE)
      IF(rec >= 0) THEN
        DisplayRecord(rec, $$TRUE)
      ELSE
        ShowMessage("No Records Found!")
      END IF

   END SUB

END FUNCTION

' ###########################
' #####  MarkRecord ()  #####
' ###########################
'
FUNCTION  MarkRecord (record, state)
  SHARED RECORD RecordList[]

  #UpdateSummaryFields = $$TRUE
  RecordList[record].marked = state
END FUNCTION

' ##############################
' #####  CreateProject ()  #####
' ##############################
'
FUNCTION  CreateProject ()
   IF(#CurrentProject$) THEN
      IFZ(CloseProject($$TRUE, $$FALSE)) THEN RETURN
   END IF
  XuiDialog("Enter Project Name", "", @kid, @message$)
  IF(kid == 2 || kid == 3) THEN
    #CurrentProject$ = #ProjectDirectory$ + message$
    Log($$LOG_INFO, #CurrentProject$)
    err = XstMakeDirectory(@#CurrentProject$)
      IF(err) THEN
            err$ = "Either the project directory\nalready exists, or the directory\ncould not be created."
            ShowMessage("Could not create project!\n" + err$)
           #CurrentProject$ = ""
           RETURN $$FALSE
      END IF
         XstSetCurrentDirectory(@#CurrentProject$)
      err = XstMakeDirectory(#CurrentProject$ + $$PathSlash$ + $$STATIC_IMAGE_DIR$)
      db$ = #CurrentProject$ + $$PathSlash$ + message$ + ".db"

         err = SQL_CreateDatabase(@db$, @message$)
         IF(err == $$FALSE) THEN
            err$ = "There was an error creating the database file."
            ShowMessage("Could not create project! " + err$)
            XstDeleteFile(@#CurrentProject$)
           #CurrentProject$ = ""
           RETURN $$FALSE
         END IF

         CreateGeoFile(@db$, @message$)
         #FirstField = $$TRUE
         err$ = $$MAIN_TITLE$ + "-" + message$
         XuiSendMessage(#GeoFile, #SetWindowTitle, 0,0,0,0,0, @err$)
         ShowMessage("Project successfully created.\nGo ahead and start adding fields")
         RETURN $$TRUE
   END IF

   RETURN $$FALSE
END FUNCTION

' ###########################
' #####  SaveLayout ()  #####
' ###########################
'
FUNCTION  SaveLayout (layout$)
   SHARED FIELD FieldList[]
   SHARED FIELD LabelList[]
   FIELD temp

   file$ = #CurrentProject$ + $$PathSlash$ + layout$
   fd = OPEN(file$, $$WRNEW)
   IF(fd <= 0) THEN
      Log($$LOG_DEBUG, "Count not open layout file: " + layout$)
      ShowMessage("Could not save layout!")
      RETURN $$FALSE
   END IF
   fields = UBOUND(FieldList[]) + 1
   WRITE [fd], fields
   FOR i = 0 TO UBOUND(FieldList[])
      temp = FieldList[i]
      WRITE [fd],temp
   NEXT i

   labels = UBOUND(LabelList[]) + 1
   WRITE [fd], labels
   FOR i = 0 TO UBOUND(LabelList[])
      temp = LabelList[i]
      WRITE [fd],temp
   NEXT i

   'save colors of grid
   XuiSendMessage(#CanvasGrid, #GetColor, @back, @text, @low, @high,0,0)
   WRITE [fd], back, text, low, high

   XuiSendMessage(#CanvasGrid, #GetBorder, @b1, @b2, @b3, @b4, 0,0)
   WRITE [fd], b1, b2, b3, b4

   fields = LEN(#BackgroundImage$)
   WRITE [fd], fields
   WRITE [fd], #BackgroundImage$

   'save page size
   WRITE [fd], #PageWidth
   WRITE [fd], #PageHeight

   CLOSE(fd)
   #LayoutModified = $$FALSE
   Log($$LOG_INFO, "Saved Layout")

   RETURN $$TRUE
END FUNCTION

' ###############################
' #####  GetLabelByGrid ()  #####
' ###############################
'
FUNCTION  GetLabelByGrid (grid, @index)
   SHARED FIELD LabelList[]

   index = -1
   FOR i = 0 TO UBOUND(LabelList[])
      IF(grid == LabelList[i].grid) THEN
         index = i
         RETURN $$TRUE
      END IF
   NEXT i

   RETURN $$FALSE

END FUNCTION

' ###########################
' #####  LoadLayout ()  #####
' ###########################
'
FUNCTION  LoadLayout (layout$, resize, load_fields)
   SHARED FIELD FieldList[]
   SHARED FIELD LabelList[]
   UBYTE image[]
   FIELD temp


    IF(load_fields) THEN
      IFZ(LoadFields(layout$, resize)) THEN RETURN $$FALSE
    END IF

    #LayoutModified = $$FALSE
    #UpdateSummaryFields = $$TRUE

    XuiSendMessage(#GeoFile, #Redraw, 0,0,0,0,0,0)

    file$ = #CurrentProject$ + $$PathSlash$ + layout$

    fd = OPEN(file$, $$RD)

    IF(fd <= 0) THEN
      Log($$LOG_DEBUG, "LoadLayout(): Could not open layout " + layout$)
      ShowMessage("Could not load: " + layout$)
      RETURN $$FALSE
    END IF

    #CurrentLayout$ = layout$
    fields = 0
    READ [fd],fields

    FOR i = 0 TO fields - 1
      temp = FieldList[i]
      READ [fd],temp
      temp.grid = FieldList[i].grid
      FieldList[i] = temp

      'Set position
      x = FieldList[i].x
      y = FieldList[i].y
      w = FieldList[i].w
      h = FieldList[i].h
      XgrGetGridPositionAndSize(FieldList[i].grid, @cx, @cy, @cw, @ch)
      delta_x = x - cx
      delta_y = y - cy
      delta_w = w - cw
      delta_h = h - ch
      XgrSetGridPositionAndSize(FieldList[i].grid, cx + delta_x, cy + delta_y, w, h)
      XuiGetKidArray(temp.grid, #GetKidArray, @g, @parent, 0,0,0, @kids[])
      IF(UBOUND(kids[]) > 0) THEN
         'Move kids
         FOR z = 1 TO UBOUND(kids[])
            XgrGetGridPositionAndSize(kids[z], @x, @y, @w, @h)
            IF(z == 1) THEN
              XgrSetGridPositionAndSize(kids[z], (x + delta_x), (y + delta_y), (w + delta_w), (h + delta_h))
            ELSE
              XgrSetGridPositionAndSize(kids[z], (x + delta_x), (y + delta_y), w, h)
            END IF
         NEXT z
      END IF

      'Set font, border, and colors
      XuiSendMessage(FieldList[i].grid, #SetColor, FieldList[i].backcolor, FieldList[i].textcolor, FieldList[i].lowcolor, FieldList[i].highcolor,0,0)
      XuiSendMessage(FieldList[i].grid, #SetBorder, FieldList[i].border1, FieldList[i].border2, FieldList[i].border3, FieldList[i].border4,0,0)
      XuiSendMessage(FieldList[i].grid, #SetFont, FieldList[i].fontSize, FieldList[i].fontWeight, FieldList[i].fontItalic,FieldList[i].fontAngle,0,FieldList[i].fontName)

      'Set visibility
      IF(FieldList[i].visible == $$FALSE || FieldList[i].in_layout == $$FALSE) THEN
         XuiSendMessage(FieldList[i].grid, #Disable, 0,0,0,0,0,0)
      ELSE
         XuiSendMessage(FieldList[i].grid, #Enable, 0,0,0,0,0,0)
      END IF
    NEXT i

   READ [fd],fields

   FOR i = 0 TO fields - 1
      temp = LabelList[i]
      READ [fd],temp
      temp.grid = LabelList[i].grid
      LabelList[i] = temp

      'Set Position
      x = LabelList[i].x
      y = LabelList[i].y
      w = LabelList[i].w
      h = LabelList[i].h
      XgrGetGridPositionAndSize(LabelList[i].grid, @cx, @cy, @cw, @ch)
      delta_x = x - cx
      delta_y = y - cy
      XgrSetGridPositionAndSize(LabelList[i].grid, x, y, w, h)

      'Set font, border, and colors
      XuiSendMessage(LabelList[i].grid, #SetColor, LabelList[i].backcolor, LabelList[i].textcolor, LabelList[i].lowcolor, LabelList[i].highcolor,0,0)
      XuiSendMessage(LabelList[i].grid, #SetBorder, LabelList[i].border1, LabelList[i].border2, LabelList[i].border3, LabelList[i].border4,0,0)
      XuiSendMessage(LabelList[i].grid, #SetFont, LabelList[i].fontSize, LabelList[i].fontWeight, LabelList[i].fontItalic,LabelList[i].fontAngle,0,LabelList[i].fontName)

      'Set Visibility
      IF(LabelList[i].visible == $$FALSE || LabelList[i].in_layout == $$FALSE) THEN
        XuiSendMessage(LabelList[i].grid, #Disable, 0,0,0,0,0,0)
      ELSE
        XuiSendMessage(LabelList[i].grid, #Enable, 0,0,0,0,0,0)
      END IF
   NEXT i

   'Read background color of canvas grid
   READ [fd], back, text, low, high
   XuiSendMessage(#CanvasGrid, #SetColor, back, text, low, high, 0 ,0)

   'Read border of canvas grid
   READ [fd], b1, b2, b3, b4
   XuiSendMessage(#CanvasGrid, #SetBorder, b1, b2, b3, b4, 0, 0)

    'Read layouts background image
    READ [fd],fields
   IF(fields > 0) THEN
       #BackgroundImage$ = NULL$(fields)
       READ[fd], #BackgroundImage$
   ELSE
     #BackgroundImage$ = ""
   END IF

   READ [fd], #PageWidth
   READ [fd], #PageHeight
   ResizePage(#PageWidth, #PageHeight)
   SetBackgroundImage(#BackgroundImage$, $$FALSE)

   OrganizerCode(#Organizer, #Notify, 0,0,0,0,0,0)
   ModifyPageCode(#ModifyPage, #Notify,0,0,0,0,0,0)
   XuiSendMessage(#CanvasGrid, #Redraw, 0,0,0,0,0,0)
   CLOSE(fd)
END FUNCTION

' #######################
' #####  Select ()  #####
' #######################
'
FUNCTION  Select (message, @r0)
  STATIC POINT start
  STATIC POINT delta
  POINT mouse_xy
  POINT end
  POINT temp_start
  POINT temp_end
  FIELD temp_field
  SHARED FIELD FieldList[]
  SHARED FIELD LabelList[]
  SHARED RECORD RecordList[]
  SHARED SEL_LIST SelList[]
  XLONG seltype
  XLONG index                      'index of field in FieldList
  XLONG x                             'x position of grid
  XLONG y                             'y position of grid
  XLONG state
  XLONG time
  XLONG w                             'width
  XLONG h                             'height
  XLONG i                             'counter
  temp$ = ""                      'text string of focus Field

  XgrGetMouseInfo(@window, @grid, @x, @y, @state, @time)
  GOSUB CheckEventSource

  'Special mouse handling for Data mode
  IF(#DesignMode == $$FALSE) THEN
    IF(message == #WindowMouseDown) THEN
      IF(IsFieldSelected(grid, @index)) THEN
        IF(FieldList[index].grid_type == $$IMAGE) THEN
          SetImage(grid, index, #CurrentRecord, $$TRUE)
        END IF
      END IF
    END IF
    RETURN
  END IF

  mouse_xy.x = x
  mouse_xy.y = y

  SELECT CASE message
    CASE #WindowMouseDown: GOSUB MouseDown : r0 = -1
    CASE #WindowMouseUp:   GOSUB MouseUp   : r0 = -1
    CASE #WindowMouseDrag: GOSUB MouseDrag : r0 = -1
  END SELECT

  DrawSelectionRectangle(@SelList[])

  SUB MouseDown
    seltype = -1
    SELECT CASE TRUE
      CASE IsFieldSelected(grid, @index):
        #SelectedGrid = FieldList[index].grid
        seltype = $$ENTRY
      CASE IsLabelSelected(grid, @index):
        #SelectedGrid = grid
        seltype = $$LABEL
    END SELECT

    XgrSetGridBuffer(#CanvasGrid, 0,0,0)

    start.x = x
    start.y = y
    delta.x = 0
    delta.y = 0

    IF(seltype == -1) THEN #SelectedGrid = 0

    'User has clicked on Field or Label
    IF(#SelectedGrid != 0) THEN
      FieldPropertiesCode(#FieldProperties, #Notify,0,0,0,0,0,0)
      XuiSendMessage(#GeoFile, #SelectWindow, 0,0,0,0,0,0)
     'See if user clicked on an already selected grid
      IF(CheckSelListByGrid(@SelList[], #SelectedGrid) == -1) THEN
        'Check for Ctrl key down
        state = state{1,17}
        IF(state == 1) THEN
          REDIM SelList[UBOUND(SelList[]) + 1]
          SelList[UBOUND(SelList[])].index = index
          SelList[UBOUND(SelList[])].type = seltype
          SelList[UBOUND(SelList[])].grid = #SelectedGrid
        ELSE
          REDIM SelList[]
          XuiSendMessage(#CanvasGrid, #Redraw,0,0,0,0,0,0)
        END IF
      END IF

      IFZ(SelList[]) THEN
        REDIM SelList[0]
        SelList[0].index = index
        SelList[0].type = seltype
        SelList[0].grid = #SelectedGrid
      END IF
    'User did not select a Field or Label
    ELSE
      IF(grid != #CanvasGrid) THEN RETURN
      IF(SelList[]) THEN
        REDIM SelList[]
        XgrRefreshGrid(#CanvasGrid)
        XuiSendMessage(#CanvasGrid, #Redraw,0,0,0,0,0,0)
      END IF
    END IF
    XgrRefreshGrid(#CanvasGrid)
    XgrCopyImage(#CanvasGridBuffer, #CanvasGrid)
  END SUB

  SUB MouseDrag
    IF(#SelectedGrid > 0) THEN
      GOSUB CheckBounds
      GOSUB UpdateDelta
      MoveSelectedObjects(@SelList[], delta)
      XgrCopyImage(#CanvasGrid, #CanvasGridBuffer)
    ELSE
      IF(grid != #CanvasGrid) THEN RETURN
      XgrCopyImage(#CanvasGrid, #CanvasGridBuffer)
      XgrDrawBoxGrid(#CanvasGrid, $$Green, start.x, start.y, x, y)
      end.x = x
      end.y = y
      temp_end = end
      temp_start = start
      AdjustRect(@temp_start, @temp_end)
      GetSelectedFields(temp_start, temp_end, @SelList[])
      DrawRuler($$RULER_DRAW, #RulerMode)
    END IF
  END SUB

  SUB MouseUp
    IF(#SelectedGrid == 0) THEN
      IF(SelList[]) THEN #SelectedGrid = SelList[0].grid
    END IF
    UpdateRuler($$RULER_CLEAR, $$FALSE) : DrawRuler($$RULER_DRAW, #RulerMode)
    IF(start.x != x || start.y != y || delta.x != 0 || delta.y != 0) THEN
      XgrClearGrid(#CanvasGridBuff, #CANVAS_COLOR)
      XgrSetGridBuffer(#CanvasGrid, #CanvasGridBuffer, #buffX, #buffY)
      XuiSendMessage(#GeoFile, #Redraw, 0,0,0,0, 0, 0)
    END IF
  END SUB

  SUB UpdateDelta
    delta.x = x - start.x
    delta.y = y - start.y
  END SUB

  'Ignore mouse events NOT in Canvas grid or any of its kids
  SUB CheckEventSource
    SELECT CASE TRUE
      CASE grid == #CanvasGrid     : EXIT SUB
      CASE GetFieldByGrid(grid, @i): EXIT SUB
      CASE GetLabelByGrid(grid, @i): EXIT SUB
    END SELECT
    RETURN
  END SUB

  'Prevent user from moving grids out of canvas area
  SUB CheckBounds
    FOR i = 0 TO UBOUND(SelList[])
      SELECT CASE SelList[i].type
        CASE $$ENTRY:
          temp_field = FieldList[SelList[i].index]
          temp_field.x = temp_field.x + (x - start.x)
          temp_field.y = temp_field.y + (y - start.y)
          IFZ(IsFieldVisible(temp_field)) THEN
             RETURN
          END IF
        CASE $$LABEL:
          temp_field = LabelList[SelList[i].index]
          temp_field.x = temp_field.x + (x - start.x)
          temp_field.y = temp_field.y + (y - start.y)
          IFZ(IsFieldVisible(temp_field)) THEN
             RETURN
          END IF
      END SELECT
    NEXT i
  END SUB

END FUNCTION

' ##################################
' #####  GetSelectedFields ()  #####
' ##################################
'
FUNCTION  GetSelectedFields (POINT start, POINT end, SEL_LIST list[])
   SHARED FIELD FieldList[]
   SHARED FIELD LabelList[]
   FIELD temp
   RECTANGLE sr
   RECTANGLE sel
   XLONG count
   XLONG found
   POINT s
   POINT e

   REDIM list[]
   count = 0
   found = 0
   sel.start.x = start.x
   sel.start.y = start.y
   sel.end.x = end.x
   sel.end.y = end.y
   FOR i = 0 TO UBOUND(FieldList[])
      temp = FieldList[i]
      GOSUB CheckBounds
      IF(found) THEN
             FieldList[i].selected = $$TRUE
         REDIM list[count]
         list[count].index = i
             list[count].type = $$ENTRY
             list[count].grid = FieldList[i].grid
         INC count
      END IF
   NEXT i

    FOR i = 0 TO UBOUND(LabelList[])
      temp = LabelList[i]
      GOSUB CheckBounds
      IF(found) THEN
             LabelList[i].selected = $$TRUE
         REDIM list[count]
         list[count].index = i
             list[count].type = $$LABEL
             list[count].grid = LabelList[i].grid
         INC count
      END IF
    NEXT i

   RETURN count

   SUB CheckBounds
      IF(temp.visible == $$FALSE || temp.in_layout == $$FALSE) THEN
        found = $$FALSE
        EXIT SUB
      END IF
      GetFieldSR(temp, @sr)
      IF(IsRectInRect(sr, sel)) THEN
         found = $$TRUE
      ELSE
         found = $$FALSE
      END IF
   END SUB

END FUNCTION
'
'
' #############################
' #####  IsRectInRect ()  #####
' #############################
'
FUNCTION  IsRectInRect (RECTANGLE a, RECTANGLE b)
   IF(a.start.x > b.start.x && a.end.x < b.end.x) THEN
      IF(a.start.y > b.start.y && a.end.y < b.end.y) THEN
         RETURN $$TRUE
      END IF
   END IF

   RETURN $$FALSE

END FUNCTION
'
'
' ###########################
' #####  GetFieldSR ()  #####
' ###########################
'
' Im not currently maintaining the surrounding
' rectangle anywhere, Im always recalculating it on the fly
FUNCTION  GetFieldSR (FIELD f, RECTANGLE sr)
   sr.start.x = f.x
   sr.end.x = f.x + f.w
   sr.start.y = f.y
   sr.end.y = f.y + f.h
END FUNCTION

' ####################################
' #####  MoveSelectedObjects ()  #####
' ####################################
'
FUNCTION  MoveSelectedObjects (SEL_LIST list[], POINT delta)
  FOR i = 0 TO UBOUND(list[])
    grid = list[i].grid
    MoveObject(grid, list[i].index, list[i].type, delta)
  NEXT i
END FUNCTION

' ###################################
' #####  CheckSelListByGrid ()  #####
' ###################################
'
FUNCTION  CheckSelListByGrid (SEL_LIST list[], grid)

   FOR i = 0 TO UBOUND(list[])
      IF(list[i].grid == grid) THEN RETURN i
   NEXT i

   RETURN -1

END FUNCTION

' ####################################
' #####  CheckSelListByIndex ()  #####
' ####################################
'
FUNCTION  CheckSelListByIndex (SEL_LIST list[], index)


END FUNCTION

' ###########################
' #####  AdjustRect ()  #####
' ###########################
'
' Make sure start is upper-left, end is lower-right
FUNCTION  AdjustRect (POINT start, POINT end)
   XLONG temp

   IF(end.x < start.x) THEN
    temp = end.x
    end.x = start.x
    start.x = temp
  END IF
  IF(end.y < start.y) THEN
    temp = end.y
    end.y = start.y
    start.y = temp
  END IF

END FUNCTION

' ###############################
' #####  MoveAllObjects ()  #####
' ###############################
'
FUNCTION  MoveAllObjects (deltax, deltay)
   SHARED FIELD FieldList[]
   SHARED FIELD LabelList[]

   #LayoutModified = $$TRUE

   FOR i = 0 TO UBOUND(FieldList[])
      grid = FieldList[i].grid
      XgrGetGridPositionAndSize(grid, @x, @y, @w, @h)
      XgrSetGridPositionAndSize(grid, (x + deltax), (y + deltay), w, h)
      IF(IsFieldVisible(FieldList[i])) THEN
        FieldList[i].visible = $$TRUE
        XuiSendMessage(grid, #Enable, 0,0,0,0,0,0)
      ELSE
        FieldList[i].visible = $$FALSE
        XuiSendMessage(grid, #Disable, 0,0,0,0,0,0)
      END IF
      XuiGetKidArray(grid, #GetKidArray, @g, @parent, 0,0,0, @kids[])
      IF(kids[]) THEN
        'Move kids
        FOR z = 1 TO UBOUND(kids[])
        XgrGetGridPositionAndSize(kids[z], @x, @y, @w, @h)
        XgrSetGridPositionAndSize(kids[z], (x + deltax), (y + deltay), w, h)
        NEXT z
      END IF
      FieldList[i].x = FieldList[i].x + deltax
      FieldList[i].y = FieldList[i].y + deltay
   NEXT i

   FOR i = 0 TO UBOUND(LabelList[])
      grid = LabelList[i].grid
      IF(IsFieldVisible(LabelList[i])) THEN
        LabelList[i].visible = $$TRUE
        XuiSendMessage(grid, #Enable, 0,0,0,0,0,0)
      ELSE
        LabelList[i].visible = $$FALSE
        XuiSendMessage(grid, #Disable, 0,0,0,0,0,0)
      END IF
      XgrGetGridPositionAndSize(grid, @x, @y, @w, @h)
      XgrSetGridPositionAndSize(grid, (x + deltax), (y + deltay), w, h)
      LabelList[i].x = LabelList[i].x + deltax
      LabelList[i].y = LabelList[i].y + deltay
   NEXT i

END FUNCTION
'
'
' ##############################
' #####  GetFieldNames ()  #####
' ##############################
'
FUNCTION  GetFieldNames (@names$[])
   SHARED FIELD FieldList[]

   REDIM names$[]
   FOR i = 0 TO UBOUND(FieldList[])
         REDIM names$[i]
         names$[i] = FieldList[i].name
   NEXT i

END FUNCTION
'
'
' #############################
' #####  SQL_AddTable ()  #####
' #############################
'
FUNCTION  SQL_AddTable (name$)
   IF(#DB == 0) THEN RETURN $$FALSE

   sql$ = "CREATE TABLE " + name$
   sql$ = sql$ + " (" + $$SQL_INDEX_COLUMN$ + " INTEGER_PRIMARY_KEY);"
   ret = sqlite3_exec(#DB, &sql$, &SQLCallback(), $$DB_CREATE_TABLE, &err)

  IF(ret <> 0) THEN
    err$ = CSTRING$(err)
    Log($$LOG_ERROR, err$)
    'These error strings need to be freed!
    RETURN $$FALSE
  END IF
  #TableName$ = name$

   RETURN $$TRUE
END FUNCTION
'
'
' ###################################
' #####  SQL_CreateDatabase ()  #####
' ###################################
'
FUNCTION  SQL_CreateDatabase (@fqname$, @dbname$)
  err = sqlite3_open(&fqname$, &#DB)
  IF(err == 0) THEN
    SQL_AddTable(@dbname$)
  ELSE
    RETURN $$FALSE
  END IF

  RETURN $$TRUE
END FUNCTION
'
'
' ##############################
' #####  CreateGeoFile ()  #####
' ##############################
'
FUNCTION  CreateGeoFile (@db$, @table$)
  DIM file$[4]

  file$[0] = "database"
  file$[1] = db$
  file$[2] = "table"
  file$[3] = table$

  name$ = #CurrentProject$ + $$PathSlash$ + table$ + ".geo"
  XstSaveStringArray(@name$, @file$[])

END FUNCTION
'
'
' ##############################
' #####  SQL_AddColumn ()  #####
' ##############################
'
FUNCTION  SQL_AddColumn (@name$, type, len)

   sql$ = "ALTER TABLE " + #TableName$ + " ADD "
   sql$ = sql$ + name$
   SELECT CASE type
      CASE $$FT_STRING_SINGLE, $$FT_STRING_MULTI:
         type$ = "VARCHAR(" + TRIM$(STR$(len)) + ")"
      CASE $$FT_INTEGER:
      CASE $$FT_REAL:
      CASE $$FT_DATE:
      CASE $$FT_SUMMARY:
      CASE $$FT_IMAGE:
         type$ = "VARCHAR(" + STRING$($$DEFAULT_NUM_SIZE) + ")"
   END SELECT
   sql$ = sql$ + " " + type$
   ret = sqlite3_exec(#DB, &sql$, &SQLCallback(), $$DB_CREATE_COLUMN, &err)

  IF(ret <> 0) THEN
    err$ = CSTRING$(err)
    Log($$LOG_ERROR, err$)
  END IF
END FUNCTION

' ################################
' #####  GetNextRecordId ()  #####
' ################################
'
' Get list of all record id's
' Sort them in ascending order
' Find lowest available next record id
FUNCTION  GetNextRecordId ()
   SHARED RECORD RecordList[]

   REDIM #Buff[]
   'List is empty, use id 1
   IFZ(RecordList[]) RETURN 1

   upper = UBOUND(RecordList[])

   FOR i = 0 TO upper
      REDIM #Buff[i]
      #Buff[i] = RecordList[i].id
   NEXT i

   XstQuickSort(@#Buff[], @null[], 0, UBOUND(#Buff[]), $$SortIncreasing)

   IF(#Buff[0] != 1) THEN RETURN 1
   FOR i = 0 TO upper - 1
      IF(#Buff[i + 1] - #Buff[i] > 1) THEN
         RETURN #Buff[i] + 1
      END IF
   NEXT i

   RETURN #Buff[i] + 1
END FUNCTION
'
'
' #############################
' #####  CloseProject ()  #####
' #############################
'
FUNCTION  CloseProject (prompt, quitting)
  SHARED RECORD RecordList[]
  SHARED FIELD FieldList[]
  SHARED FIELD LabelList[]

  IF(prompt) THEN
    IF(#LayoutModified) THEN
      msg$ = "The layout has been modified.\nWould you like to save it?"
      IF(AskYesNo(@msg$)) THEN
         SaveLayout(#CurrentLayout$)
      END IF
    END IF

    'Check for unsaved records
    GetDirtyRecords(@#Buff[])
    IF(#Buff[]) THEN
      msg$ = "": msg$= "There are unsaved records.\nWould you like to save them?"
      IF(AskYesNo(@msg$)) THEN
         FOR i = 0 TO UBOUND(#Buff[])
           IFZ(SaveRecord(#Buff[i])) THEN
             RETURN $$FALSE
           END IF
         NEXT i
      END IF
    END IF
    REDIM #Buff[]
  END IF

  IF(#DB > 0) THEN
    sqlite3_close(#DB)
    #DB = 0
  END IF

  IF(quitting) THEN RETURN $$TRUE

  ClearCanvas()
  #CurrentProject$ = ""

  InitProgram($$FALSE)
  InitWindows($$FALSE)

  'Clean organizer
  OrganizerCode(#Organizer, #Notify, 0,0,0,0,0,0)

  XstGetConsoleGrid(@grid)
  XuiSendMessage(grid, #SetWindowTitle, 0,0,0,0,0, @$$CONSOLE_TITLE$)
  XuiSendMessage(#GeoFile, #SetWindowTitle, 0,0,0,0,0, @$$MAIN_TITLE$)
  RETURN $$TRUE
END FUNCTION
'
'
' #############################
' #####  OpenProject ()  #####
' #############################
'
FUNCTION  OpenProject (file$)
  SHARED Layouts$[]

   IF(#CurrentProject$) THEN
      IFZ(CloseProject($$TRUE, $$FALSE)) THEN RETURN $$FALSE
   END IF
   IF(ReadGeoFile(@file$)) THEN
      #GeoFile$ = file$
      XstGetPathComponents(@file$, @path$, @drive$, @dir$, @filename$, @attr)
      #CurrentProject$ = RCLIP$(path$)
      XstSetCurrentDirectory(@path$)
      GetLayouts(@Layouts$[])
      LoadLayout(#DefaultLayout$, $$TRUE, $$TRUE)
      IF(ReadDatabaseFile(#DataFile$)) THEN
        DisplayRecord(0, $$TRUE)
        title$ = $$MAIN_TITLE$ + "-" + #TableName$
        XuiSendMessage(#GeoFile, #SetWindowTitle, 0,0,0,0,0, @title$)
        XstGetConsoleGrid(@attr)
        title$ = $$CONSOLE_TITLE$ + "-" + #TableName$
        XuiSendMessage(attr, #SetWindowTitle, 0,0,0,0,0, @title$)
        RETURN $$TRUE
      ELSE
        RETURN $$FALSE
      END IF
    ELSE
      RETURN $$FALSE
   END IF
END FUNCTION
'
'
' ##############################
' #####  ExportRecords ()  #####
' ##############################
'
' Replaces embedded commas with spaces.  This is so XFile
' can at least properly import files it exports.
'
' This is a mess
FUNCTION  ExportRecords (@file$, type, mode)
   SHARED RECORD RecordList[]
   SHARED XLONG RecordOrder[]
   SHARED StringData$[]
   STRING out$[]
   UBYTE image[]

   SELECT CASE type
      CASE $$EXPORT_CSV: GOSUB ExportCSV
      CASE $$EXPORT_BMP: GOSUB ExportBMP
      CASE $$EXPORT_HTML : GOSUB ExportHTML
   END SELECT

  'Simple CSV export. If a field is empty, puts a '0' in there.
  'This is so ImportRecords will import it properly.
  SUB ExportCSV
    count = 0
    IF(mode == $$EXPORT_CURRENT) THEN
      i = #CurrentRecord
      GOSUB ExportRecord
      INC count
      GOSUB FinishExport
    END IF

    FOR x = 0 TO UBOUND(RecordOrder[])
      SELECT CASE mode
        CASE $$EXPORT_ALL:
          i = RecordOrder[x]
          GOSUB ExportRecord
          INC count
        CASE $$EXPORT_MARKED:
          IF(RecordList[RecordOrder[x]].marked) THEN
            i = RecordOrder[x]
            GOSUB ExportRecord
            INC count
          END IF
      END SELECT
    NEXT x

    GOSUB FinishExport
  END SUB

  SUB ExportRecord
    REDIM out$[UBOUND(out$[]) + 1]
    FOR z = RecordList[i].first TO RecordList[i].last
      temp$ = StringData$[z]
      GOSUB ReplaceNewlines
      SELECT CASE TRUE
        CASE INSTR(StringData$[z], ",") :
          temp$ = StringData$[z]
          FOR foo = 0 TO LEN(temp$) - 1
            IF(temp${foo} == ',') THEN temp${foo} = ' '
          NEXT foo
        CASE StringData$[z] == "" :
          temp$ = "0"
      END SELECT
      line$ = line$ + temp$
      IF(z != RecordList[i].last) THEN
        line$ = line$ + ","
      END IF
    NEXT z
    out$[UBOUND(out$[])] = line$
    line$ = ""
    temp$ = ""
  END SUB

  SUB ExportBMP
    'Process all remaining messages
    XuiSendMessage(#CanvasGrid, #Redraw, 0,0,0,0,0,0)
    XgrMessagesPending(@count)
    IF(count > 0) THEN
      XgrProcessMessages(count)
    END IF

    count = 0
    IF(mode == $$EXPORT_CURRENT) THEN
      GOSUB SaveBMP
      GOSUB FinishExport
    END IF

    FOR i = 0 TO UBOUND(RecordOrder[])
      SELECT CASE mode
        CASE $$EXPORT_ALL:
          DisplayRecord(RecordOrder[i], $$FALSE)
          GOSUB SaveBMP
        CASE $$EXPORT_MARKED:
          IF(RecordList[RecordOrder[i]].marked) THEN
            DisplayRecord(RecordOrder[i], $$FALSE)
            GOSUB SaveBMP
          END IF
      END SELECT
    NEXT i
    GOSUB FinishExport
  END SUB

  SUB ExportHTML
    count = ExportHTML(@file$, mode)
    GOSUB FinishExport
  END SUB

  SUB FinishExport
    Log($$LOG_INFO, "Exported " + STRING$(count) + " records.")
    IF(type == $$EXPORT_CSV && count > 0) THEN XstSaveStringArray(@file$, @out$[])
    DisplayRecord(#CurrentRecord, $$TRUE)
    RETURN
  END SUB

  SUB SaveBMP
    XgrGetImage(#CanvasGrid, @image[])
    IF(image[]) THEN
      err = XgrSaveImage(#CurrentProject$ + "\\" + #TableName$ + "_" + STRING$(RecordOrder[i]) + ".bmp", @image[])
      IF(err == 0) THEN
        INC count
      ELSE
        Log($$LOG_ERROR, "Error exporting record " + STRING(RecordOrder[i]))
      END IF
    END IF
  END SUB

   SUB ReplaceNewlines
     DO
       pos = INSTR(temp$, "\n", pos)
       IF(pos <= 0) THEN EXIT DO
       temp${pos - 1} = 0x20
       INC pos
     LOOP
   END SUB
END FUNCTION

' ###############################
' #####  IsFieldVisible ()  #####
' ###############################
'
' A field can be invisible by
' 1. being out of the CavansRect area
' 2. Not being in the current layout
'
FUNCTION  IsFieldVisible (FIELD field)
  RECTANGLE canvas
  RECTANGLE sr

  IF(field.in_layout == $$FALSE) THEN RETURN $$FALSE

  XgrGetGridPositionAndSize(#CanvasGrid, @gx, @gy, @gw, @gh)

  canvas.start.x = 0 + width : canvas.start.y = 0 + width
  canvas.end.x = gw : canvas.end.y = gh
  GetFieldSR(@field, @sr)
  IF(IsRectInRect(@sr, @canvas)) THEN
    RETURN $$TRUE
  ELSE
    RETURN $$FALSE
  END IF

END FUNCTION

' ##############################
' #####  ImportRecords ()  #####
' ##############################
'
'Very simple CSV import/export
FUNCTION  ImportRecords (@file$, type)
   SHARED FIELD FieldList[]
   SHARED RECORD RecordList[]

   IFZ(#CurrentProject$) THEN
      ShowMessage("You must open or create a project first!")
      RETURN $$FALSE
   END IF

   IFZ(FieldList[]) THEN
      ShowMessage("You must add at least one field first!")
      RETURN $$FALSE
   END IF

   SELECT CASE type
      CASE $$IMPORT_CSV: GOSUB ImportCSV
   END SELECT

   'Very simple CSV import.  Pays no attention to quoted fields.
   SUB ImportCSV
      XstLoadStringArray(@file$, @lines$[])
      IFZ(lines$[]) THEN ShowMessage("Error in CSV file!") : RETURN $$FALSE
      GOSUB TestColumnCount
      FOR i = 0 TO UBOUND(lines$[])
        IF(LEN(lines$[i]) > 0) THEN
          AddRecord(@record, $$TRUE, 0)
          Tokenize(lines$[i], @data$[], @",")
          FOR z = 0 TO fields
            AddRecordData(record, z, data$[z])
          NEXT z
          DisplayRecord(record, $$TRUE)
          RecordList[record].dirty = $$TRUE
         END IF
         XgrProcessMessages(0)
      NEXT i
      ShowMessage("Finished importing" + STR$(i) + " records.")
   END SUB

   SUB TestColumnCount
      fields = UBOUND(FieldList[])
      start = 0
      cols = 0
      DO
         'This assumes no embedded commas!
         start = INSTR(lines$[0], ",", start + 1)
         IF(start > 0) THEN
            INC cols
         ELSE
            EXIT DO
         END IF
      LOOP
      IF(cols != fields) THEN
         ShowMessage("Column count of CSV\nfile does not\nmatch field count!")
         RETURN $$FALSE
      END IF
   END SUB

END FUNCTION

' ###########################
' #####  LoadFields ()  #####
' ###########################
'
' There should just be one function for loading all the fields.
'
FUNCTION  LoadFields (layout$, resize)
   FIELD temp
   SHARED FIELD FieldList[]
   SHARED FIELD LabelList[]

   file$ = #CurrentProject$ + $$PathSlash$ + layout$
   fd = OPEN(file$, $$RD)
   IFZ(fd) THEN
     Log($$LOG_DEBUG, "LoadFields(): Could not load " + layout$)
     ShowMessage("Could not load layout: " + layout$)
     RETURN $$FALSE
   END IF

   REDIM FieldList[]
   REDIM LabelList[]

   fields = 0

   '########## Read Fields #################
   READ [fd],fields
   FOR i = 0 TO fields - 1
     READ [fd],temp
     AddField(temp.name, temp.type, temp.size, resize, $$FALSE, 0, 0)
   NEXT i

   '########## Static Images and Labels ###############
   READ [fd],fields
   FOR i = 0 TO fields - 1
      READ [fd],temp
         SELECT CASE temp.grid_type
           CASE $$STATIC_IMAGE:
          AddImage(temp.x, temp.y, temp.w, temp.h, $$FALSE, temp.image)
        CASE $$LABEL
           AddLabel(temp.name, temp.x, temp.y, temp.w, temp.h, $$FALSE, @unused)
      END SELECT
   NEXT i

   CLOSE(fd)
   RETURN $$TRUE
END FUNCTION

' ################################
' #####  GetDirtyRecords ()  #####
' ################################
'
' Return a list of all record indices that are marked dirty
'
FUNCTION  GetDirtyRecords (@records[])
   SHARED RECORD RecordList[]

   REDIM records[]
   FOR i = 0 TO UBOUND(RecordList[])
      IF(RecordList[i].dirty) THEN
         REDIM records[UBOUND(records[]) + 1]
         records[UBOUND(records[])] = i
      END IF
   NEXT i

END FUNCTION

' #########################
' #####  AddImage ()  #####
' #########################
'
'Add a static image
'
'TODO Should check for supported bit depth also
'
' file$ is the full name of the bitmap, not the path
' i.e. foo.bmp not C:\files\foo.bmp
'
FUNCTION  AddImage (x1, y1, x2, y2, new, file$)
  SHARED FIELD LabelList[]
  UBYTE image[]
  XLONG w
  XLONG h

  IFZ(#CurrentProject$) THEN RETURN
  XgrGetGridWindow(#CanvasGrid, @window)

  IF(new) THEN
    GetFilename(@file$, @attr)
    IFZ(file$) THEN RETURN
    IFZ(ConvertImage(@file$, @attr)) THEN RETURN
    XgrLoadImage(@file$, @image[])
    width = XLONGAT(&image[18])
    height = XLONGAT(&image[22])
    XgrGetGridPositionAndSize(#CanvasGrid, @cx, @cy, @cw, @ch)
    IF(width > cw || height > ch) THEN
      ShowMessage("Image is bigger than the current page size!")
      RETURN
    END IF
    IF(file$) THEN
      CopyImageFile(file$, @filename$, attr)
      XstDecomposePathname(@file$, @path$, @drive$, @filename$, @thefile$, @extent$)
      file$ = "." + $$PathSlash$ + $$STATIC_IMAGE_DIR$ + $$PathSlash$ + filename$
      XuiLabel    (@g, #Create, x1, y1, width, height, window, #CanvasGrid)
      XuiSendMessage ( g, #SetBorder, $$BorderLoLine1, $$BorderLoLine1, $$BorderNone, 0, 0, 0)
      XgrSetGridPositionAndSize(g, x1, y1, width, height)
      XuiSendMessage ( g, #SetImage, 0,0,0,0,0, @file$)
      XuiSendMessage ( g, #SetHintString, 0,0,0,0,0, @file$)
      XuiSendMessage (g, #Redraw, 0,0,0,0,0,0)
      GOSUB AddImageToList
    ELSE

    END IF
  ELSE
    file$ = "." + $$PathSlash$ + $$STATIC_IMAGE_DIR$ + $$PathSlash$ + file$
    XuiLabel    (@g, #Create, x1, y1, x2, y2, window, #CanvasGrid)
    XuiSendMessage ( g, #SetBorder, $$BorderLoLine1, $$BorderLoLine1, $$BorderNone, 0, 0, 0)
    XuiSendMessage ( g, #SetImage, 0,0,0,0,0, @file$)
    XuiSendMessage ( g, #SetHintString, 0,0,0,0,0, @file$)
    XuiSendMessage (g, #Redraw, 0,0,0,0,0,0)
    GOSUB AddImageToList
  END IF

  RETURN $$TRUE

  SUB AddImageToList
    'Add label to list
    REDIM LabelList[UBOUND(LabelList[]) + 1]
    index = UBOUND(LabelList[])
    XuiSendMessage(g, #GetFontNumber, @b1, 0,0,0, 0, 0)
    XgrGetFontInfo(b1, @fname$, @fsize, @fweight, @fitalic, @fangle)
    LabelList[index].fontSize = fsize
    LabelList[index].fontWeight = fweight
    LabelList[index].fontItalic = fitalic
    LabelList[index].fontAngle = fangle
    LabelList[index].fontName = fname$
    XuiSendMessage(g, #GetColor, @b1, @b2, @b3, @b4, 0, 0)
    LabelList[index].backcolor = b1
    LabelList[index].textcolor = b2
    LabelList[index].lowcolor = b3
    LabelList[index].highcolor = b4
    XuiSendMessage(g, #GetBorder, @b1, @b2, @b3, @b4, 0, 0)
    LabelList[index].border1 = b1
    LabelList[index].border2 = b2
    LabelList[index].border3 = b3
    LabelList[index].border4 = b4
    XgrGetGridPositionAndSize(g, @gx, @gy, @width, @height)
    LabelList[index].x = gx
    LabelList[index].y = gy
    LabelList[index].w = width
    LabelList[index].h = height
    LabelList[index].selected = $$FALSE
    LabelList[index].grid = g
    LabelList[index].grid_type = $$STATIC_IMAGE
    LabelList[index].image = filename$
    LabelList[index].type = $$FT_NONE
    LabelList[index].in_layout = $$TRUE
   ' IFZ(IsFieldVisible(LabelList[index])) THEN
   '   LabelList[index].visible = $$FALSE
   '   XuiSendMessage(g, #Disable, 0,0,0,0,0,0)
   ' ELSE
   '   LabelList[index].visible = $$TRUE
   ' END IF
    LabelList[index].visible = $$TRUE
  END SUB
END FUNCTION


' ############################
' #####  SaveRecords ()  #####
' ############################
'
' I want to be able to group saves together as a transaction
' so saving large groups of records at once isnt so slow.
'
FUNCTION  SaveRecords (@records[])
   SHARED RECORD RecordList[]

   rec = #CurrentRecord
   FOR i = 0 TO UBOUND(records[])
      DisplayRecord(records[i], $$TRUE)
      SaveRecord(records[i])
      XgrProcessMessages(0)
   NEXT i
   DisplayRecord(rec, $$TRUE)

END FUNCTION

' ##############################
' #####  SetVisibility ()  #####
' ##############################
'
' Set the visibilty of a list of grids
'
FUNCTION  SetVisibility (SEL_LIST list[])
   SHARED FIELD FieldList[]
   SHARED FIELD LabelList[]

  RETURN

   FOR i = 0 TO UBOUND(list[])
      index = list[i].index

      IF(list[i].type == $$ENTRY)
         IF( FieldList[index].grid == list[i].grid) THEN
            FieldList[index].visible = IsFieldVisible(FieldList[index])
            IF(FieldList[index].visible = $$FALSE) THEN
               XuiSendMessage(list[i].grid, #Disable, 0,0,0,0,0,0)
            END IF
         END IF
      ELSE
         IF(LabelList[index].grid == list[i].grid) THEN
            LabelList[index].visible = IsFieldVisible(LabelList[index])
            IF(LabelList[index].visible = $$FALSE) THEN
               XuiSendMessage(list[i].grid, #Disable, 0,0,0,0,0,0)
            END IF
         END IF
      END IF
   NEXT i

END FUNCTION

' ###################################
' #####  SetBackgroundImage ()  #####
' ###################################
'
' Do not pass this by reference!
'
FUNCTION  SetBackgroundImage (image$, modified)
   UBYTE image[]

   IFZ(#CurrentProject$) THEN RETURN $$FALSE

   #LayoutModified = modified

   IFZ(image$) THEN
    XuiSendMessage(#CanvasGrid, #SetImage,0,0,0,0,0,0)
    #BackgroundImage$ = ""
    XuiSendMessage(#CanvasGrid, #Redraw, 0,0,0,0,0,0)
    RETURN $$TRUE
  END IF

  IFZ(ConvertImage(@image$, @converted)) THEN RETURN
  XgrLoadImage(@image$, @image[])
  IFZ(image[]) THEN
    ShowMessage("Could not load image!")
    RETURN $$FALSE
  END IF

  'Not sure if I need this
  width = XLONGAT(&image[18])
   height = XLONGAT(&image[22])

  XuiSendMessage(#CanvasGrid, #SetImage, 0,0,0,0,0, @image$)
   XuiSendMessage(#CanvasGrid, #Redraw, 0,0,0,0,0,0)
  #BackgroundImage$ = image$
END FUNCTION

' #########################
' #####  AddLabel ()  #####
' #########################
'
'Return the width the label ended up using
'
FUNCTION  AddLabel (name$, x, y, w, h, auto, @label_width)
   SHARED FIELD LabelList[]

  XgrGetGridWindow(#GeoFile, @window)

  XuiLabel    (@g, #Create, x, y, w, h, window, #CanvasGrid)
  XuiSendMessage(g, #SetTextString, 0,0,0,0,0, @name$)
  '  XuiSendMessage ( g, #SetBorder, $$BorderLoLine1, $$BorderLoLine1, $$BorderNone, 0, 0, 0)
  XuiSendMessage ( g, #SetBorder, $$BorderNone, $$BorderNone, $$BorderNone, 0, 0, 0)
  XuiSendMessage ( g, #SetTexture, $$TextureFlat, 0, 0, 0, 0, 0)
  XuiSendMessage ( g, #SetColor, $$White, $$Black, $$Black, $$White, 0, 0)
  XuiSendMessage(g, #SetJustify, $$JustifyLeft, 0,0,0,0,0)
  XgrSetGridClip(g, #CanvasGrid)

  'If autogenerated
  IF(auto) THEN
    'Adjust the width and x position, based on font
    XuiSendMessage(g, #GetFontMetrics, @font_width, @foo, @foo, @foo, 0, @foo)
    label_width = $$MAX_FIELD_NAME_LENGTH * font_width + 4
    XgrGetGridPositionAndSize(g, @x, @y, @w, @h)
    w = font_width * LEN(name$) + 2
    XgrSetGridPositionAndSize(g, label_width - w, y, w, h)
  END IF

  REDIM LabelList[UBOUND(LabelList[]) + 1]
  index = UBOUND(LabelList[])

  XuiSendMessage(g, #GetFontNumber, @b1, 0,0,0, 0, 0)
  XgrGetFontInfo(b1, @fname$, @fsize, @fweight, @fitalic, @fangle)
  LabelList[index].fontSize = fsize
  LabelList[index].fontWeight = fweight
  LabelList[index].fontItalic = fitalic
  LabelList[index].fontAngle = fangle
  LabelList[index].fontName = fname$
  XuiSendMessage(g, #GetColor, @b1, @b2, @b3, @b4, 0, 0)
  LabelList[index].backcolor = b1
  LabelList[index].textcolor = b2
  LabelList[index].lowcolor = b3
  LabelList[index].highcolor = b4
  XuiSendMessage(g, #GetBorder, @b1, @b2, @b3, @b4, 0, 0)
  LabelList[index].border1 = b1
  LabelList[index].border2 = b2
  LabelList[index].border3 = b3
  LabelList[index].border4 = b4
  XgrGetGridPositionAndSize(g, @x, @y, @w, @h)
  LabelList[index].x = x
  LabelList[index].y = y
  LabelList[index].w = w
  LabelList[index].h = h
  LabelList[index].selected = $$FALSE
  LabelList[index].grid = g
  LabelList[index].grid_type = $$LABEL
  LabelList[index].name = name$
  LabelList[index].in_layout = $$TRUE

 ' IF(IsFieldVisible(LabelList[index]) == $$FALSE) THEN
 '   LabelList[index].visible = $$FALSE
 '   XuiSendMessage(g, #Disable, 0,0,0,0,0,0)
 ' ELSE
 '   LabelList[index].visible = $$TRUE
 ' END IF
  LabelList[index].visible = $$TRUE
  RETURN index
END FUNCTION

' #########################
' #####  SetImage ()  #####
' #########################
'
FUNCTION  SetImage (grid, index, record, prompt)
  SHARED StringData$[]
  SHARED RECORD RecordList[]
  SHARED FIELD FieldList[]
  UBYTE image[]
  redraw = $$FALSE

  IF(prompt) THEN
    GetFilename(@file$, @attr)
    IFZ(file$) THEN RETURN
    IFZ(ConvertImage(@file$, @attr)) THEN RETURN
    IFZ(CopyImageFile(file$, @name$, attr)) THEN RETURN
    StringData$[RecordList[record].first + index] = name$
  ELSE
    name$ = StringData$[RecordList[record].first + index]
  END IF

  IF(name$) THEN
    image$ = "." + $$PathSlash$ + $$STATIC_IMAGE_DIR$ + $$PathSlash$ + name$
    XgrLoadImage(@image$, @image[])
  END IF

  IF(image[]) THEN
    IF(prompt) THEN
      RecordList[record].modified = $$TRUE
    END IF
    IF(FieldList[index].min == 0 && FieldList[index].max == 0) THEN
      XgrGetGridPositionAndSize(grid, @x, @y, @w, @h)
      iw = XLONGAT(&image[18]) : ih = XLONGAT(&image[22])
      IF(iw != w || ih != h) THEN
        redraw = $$TRUE
        XgrSetGridPositionAndSize(grid, x,y,iw,ih)
        FieldList[index].x = x
        FieldList[index].y = y
        FieldList[index].w = iw
        FieldList[index].h = ih
      ELSE
        redraw = $$FALSE
      END IF
    ELSE
      redraw = $$FALSE
    END IF
    XuiSendMessage(grid, #SetImage, 0,0,0,0,0, @image$)
    XuiSendMessage(grid, #SetHintString, 0,0,0,0,0, @image$)
    XuiSendMessage(grid, #RedrawGrid, 0,0,0,0,0, 0)
  ELSE
    redraw = $$FALSE
    XgrClearGrid(grid, $$IMAGE_COLOR)
    XuiSendMessage(grid, #SetImage, 0,0,0,0,0, @"")
    XuiSendMessage(grid, #RedrawGrid, 0,0,0,0,0, 0)
  END IF
  IF(redraw) THEN XuiSendMessage(#CanvasGrid, #Redraw,0,0,0,0,0,0)
END FUNCTION

' ###############################
' #####  MarkAllRecords ()  #####
' ###############################
'
' Set all records to the same marked state
'
FUNCTION  MarkAllRecords (option, state)
  SHARED RECORD RecordList[]

  FOR i = 0 TO UBOUND(RecordList[])
    SELECT CASE option
      CASE $$MARK
        RecordList[i].marked = state
      CASE $$SWITCH
        RecordList[i].marked = !RecordList[i].marked
    END SELECT

  NEXT i

END FUNCTION

' ##########################
' #####  GetFields ()  #####
' ##########################
'
' Return field indexes by a variety of checks
' visible, not visible, in layout, not in layout
'
FUNCTION  GetFields (check, fields[])
   SHARED FIELD FieldList[]
  XLONG state

  REDIM fields[]

   SELECT CASE check
      CASE $$FIELDS_IN_LAYOUT:
         state = $$TRUE
      GOSUB CheckLayout
    CASE $$FIELDS_VISIBLE:
      state = $$TRUE
      GOSUB CheckVisible
    CASE $$FIELDS_NOT_VISIBLE:
      state = $$FALSE
      GOSUB CheckVisible
    CASE $$FIELDS_NOT_IN_LAYOUT:
      state = $$FALSE
      GOSUB CheckLayout
  END SELECT

  SUB CheckVisible
    FOR i = 0 TO UBOUND(FieldList[])
      IF(FieldList[i].visible == state) THEN
        REDIM fields[UBOUND(fields[]) + 1]
        fields[UBOUND(fields[])] = i
      END IF
    NEXT i
  END SUB

  SUB CheckLayout
    FOR i = 0 TO UBOUND(FieldList[])
      IF(FieldList[i].in_layout == state) THEN
        REDIM fields[UBOUND(fields[]) + 1]
        fields[UBOUND(fields[])] = i
      END IF
    NEXT i
  END SUB
END FUNCTION

' ##########################
' #####  GetLabels ()  #####
' ##########################
'
' a stupid re-peat of GetFields()
'
FUNCTION  GetLabels (check, fields[])
  SHARED FIELD LabelList[]
  XLONG state

  REDIM fields[]

  SELECT CASE check
    CASE $$FIELDS_IN_LAYOUT:
      state = $$TRUE
      GOSUB CheckLayout
    CASE $$FIELDS_VISIBLE:
      state = $$TRUE
      GOSUB CheckVisible
    CASE $$FIELDS_NOT_VISIBLE:
      state = $$FALSE
      GOSUB CheckVisible
    CASE $$FIELDS_NOT_IN_LAYOUT:
      state = $$FALSE
      GOSUB CheckLayout
  END SELECT

  SUB CheckVisible
    FOR i = 0 TO UBOUND(LabelList[])
      IF(LabelList[i].visible == state) THEN
        REDIM fields[UBOUND(fields[]) + 1]
        fields[UBOUND(fields[])] = i
      END IF
    NEXT i
  END SUB

  SUB CheckLayout
    FOR i = 0 TO UBOUND(LabelList[])
      IF(LabelList[i].in_layout == state) THEN
        REDIM fields[UBOUND(fields[]) + 1]
        fields[UBOUND(fields[])] = i
      END IF
    NEXT i
  END SUB
END FUNCTION


' #################################
' #####  SQL_DeleteColumn ()  #####
' #################################
'
FUNCTION  SQL_DeleteColumn (column$)

  GetFieldNames(@#Buff$[])
  cols$ = "geofile_id, "
  FOR i = 0 TO UBOUND(#Buff$[])
    IF(#Buff$[i] != column$) THEN
      cols$ = cols$ + #Buff$[i]
      IF(i < UBOUND(#Buff$[])) THEN cols$ = cols$ + ", "
    ELSE
      IF(i == UBOUND(#Buff$[])) THEN cols$ = LEFT$(cols$, LEN(cols$) - 2)
    END IF
  NEXT i

  sql$ = "CREATE TEMPORARY TABLE backup(" + cols$ + "); "
  sql$ = sql$ + "INSERT INTO backup SELECT " + cols$ + " FROM " + #TableName$ +"; "
  sql$ = sql$ + "DROP TABLE " + #TableName$ + "; "
  sql$ = sql$ + "CREATE TABLE " + #TableName$ + "(" + cols$ + "); "
  sql$ = sql$ + "INSERT INTO " + #TableName$ + " SELECT " + cols$ + " "
  sql$ = sql$ + "FROM backup; "
  sql$ = sql$ + "DROP TABLE backup; "

  Log($$LOG_INFO, sql$)

  ret = sqlite3_exec(#DB, &sql$, &SQLCallback(), $$DB_DELETE_COLUMN, &err)

  IF(ret <> 0) THEN
    err$ = CSTRING$(err)
    ShowMessage(err$)
    RETURN $$FALSE
  END IF

  RETURN $$TRUE
END FUNCTION

' ############################
' #####  DeleteField ()  #####
' ############################
'
' Delete the field in a non clever way
'
' TODO find more efficient way
'
FUNCTION  DeleteField (index)
  SHARED FIELD FieldList[]
  SHARED FIELD LabelList[]
  SHARED SEL_LIST SelList[]

  REDIM SelList[]

  #LayoutModifed = $$TRUE

  DestroyGrid(FieldList[index].grid)

  IF(GetSummaryField(index, @field)) THEN
    #UpdateSummaryFields = $$TRUE
    FieldList[field].max = -1
  END IF

  IF(index == UBOUND(FieldList[])) THEN
    REDIM FieldList[UBOUND(FieldList[]) - 1]
  ELSE
    upper = UBOUND(FieldList[])

    'Update summary fields
    FOR i = index TO upper - 1
      IF(GetSummaryField(i+1, @field)) THEN
        FieldList[field].max = i
      END IF
    NEXT i

    FOR i = index TO upper - 1
      FieldList[i] = FieldList[i + 1]
    NEXT i

    REDIM FieldList[upper - 1]
  END IF

  SaveLayout(#CurrentLayout$)

END FUNCTION

' ############################
' #####  DeleteLabel ()  #####
' ############################
'
' TODO Probably is a better way to resize the array using SWAP and ATTACH
'
FUNCTION  DeleteLabel (index)
  SHARED FIELD LabelList[]

   #LayoutModifed = $$TRUE

  DestroyGrid(LabelList[index].grid)

  IF(index == UBOUND(LabelList[])) THEN
    REDIM LabelList[UBOUND(LabelList[]) - 1]
  ELSE
    upper = UBOUND(LabelList[])

    FOR i = index TO upper - 1
      LabelList[i] = LabelList[i + 1]
    NEXT i

    REDIM LabelList[upper - 1]
  END IF
END FUNCTION

' #############################
' #####  DeleteRecord ()  #####
' #############################
'
' Delete the record from the database
' REDIM RecordList
' REDIM StringData$
'
' This function is full of side effects.
'
' Deleting after sorting can cause crashes (is this still true?)
'
FUNCTION  DeleteRecord (record)
  SHARED RECORD RecordList[]
  SHARED StringData$[]
  SHARED XLONG RecordOrder[]

  #UpdateSummaryFields = $$TRUE

  sql$ = "DELETE FROM " + #TableName$ + " "
  sql$ = sql$ + "WHERE geofile_id = " + STRING$(RecordList[record].id) + ";"
  Log($$LOG_INFO, sql$)

  err = 0
  ret = sqlite3_exec(#DB, &sql$, &SQLCallback(), 4, &err)
  IF(ret == 0) THEN

    upper = UBOUND(RecordList[])
    ClearRecord(record)

    IF(upper == 0 && record == upper) THEN
         ClearFields()
      RecordList[upper].id = 1
      RecordList[upper].new = $$TRUE
      RecordList[upper].marked = $$FALSE
      RETURN $$TRUE
    END IF

    IF(upper > 0) THEN
      IF(record == upper) THEN
        'IF(#ShowOnlyMarked) THEN
        '  #CurrentRecord = GetPreviousRecord(GetOrderIndex(#CurrentRecord), $$GET_MARKED)
        'ELSE
        '  #CurrentRecord = GetPreviousRecord(GetOrderIndex(#CurrentRecord), $$GET_ORDINAL)
        'END IF
        GetIndexByRecordNumber(record, @first, @last)
        REDIM StringData$[first - 1]
        REDIM RecordList[upper - 1]
      ELSE
        'Fix up the strings
        GetIndexByRecordNumber(record, @first, @last)
        i = first
        FOR i = first TO UBOUND(StringData$[]) - (last - first + 1)
          StringData$[i] = StringData$[i + (last - first) + 1]
        NEXT i
           FOR i = record TO upper - 1
          RecordList[i] = RecordList[i + 1]
          GetIndexByRecordNumber(i, @first, @last)
          RecordList[i].first = first
          RecordList[i].last = last
        NEXT i
        'Now we have record count and size
        REDIM StringData$[i * (last - first + 1)]
      REDIM RecordList[upper - 1]
      END IF

      DeleteOrderIndex(record)
      DEC #MaxRecord
    END IF

    RETURN $$TRUE

  ELSE
    err$ = CSTRING$(err)
    ShowMessage(err$)
    RETURN $$FALSE
  END IF

END FUNCTION

' ###############################
' #####  SQL_ClearTable ()  #####
' ###############################
'
' If all of the fields (columns) have been deleted, then
' clear all geofile_ids
'
FUNCTION  SQL_ClearTable ()

  sql$ = "DELETE FROM " + #TableName$

  Log($$LOG_INFO, sql$)

  ret = sqlite3_exec(#DB, &sql$, &SQLCallback(), $$DB_CLEAR, &err)

  IF(ret <> 0) THEN
    err$ = CSTRING$(err)
    ShowMessage(err$)
    RETURN $$FALSE
  END IF

  RETURN $$TRUE
END FUNCTION

' ############################
' #####  ClearRecord ()  #####
' ############################
'
FUNCTION  ClearRecord (record)
  SHARED StringData$[]

  GetIndexByRecordNumber(record, @first, @last)
  FOR i = first TO last
    StringData$[i] = ""
  NEXT i

END FUNCTION

' #########################
' #####  AskYesNo ()  #####
' #########################
'
FUNCTION  AskYesNo (msg$)
  $xlMessage    =   1

  CenterWindow(#Confirm)
  XuiSendMessage(#Confirm, #SetTextString, 0,0,0,0,$xlMessage, @msg$)
  XuiSendMessage(#Confirm, #DisplayWindow, 0,0,0,0,0,0)
  XuiSendMessage ( #Confirm, #SetGridProperties, -1, 0, 0, 0, 0, 0)
  XuiSendMessage ( #Confirm, #GetModalInfo, @v0, @v1, @v2, @v3, @kid, 0)
  XuiSendMessage ( #Confirm, #HideWindow, 0,0,0,0,0,0)

  IF(kid == 3) THEN RETURN $$TRUE
  IF(kid == 4) THEN RETURN $$FALSE
END FUNCTION

' ####################################
' #####  DeleteMarkedRecords ()  #####
' ####################################
'
FUNCTION  DeleteMarkedRecords (@count, @err)
  record = 0
  count = 0

  DO
    rec = GetFirstRecord(@record, $$GET_MARKED)
    IF(rec >= 0) THEN
      DisplayRecord(rec, $$TRUE)
      IF(DeleteRecord(rec)) THEN
        INC count
      ELSE
        Log($$LOG_ERROR, "DeleteMarkedRecords(): Error deleting record" + STR$(rec))
        err = $$TRUE
      END IF
    ELSE
      EXIT DO
    END IF
    XgrProcessMessages(0)
  LOOP

END FUNCTION

' ######################################
' #####  GetNextViewableRecord ()  #####
' ######################################
'
' Get the next viewable record relative to
' the passed record
'
FUNCTION  GetNextViewableRecord (record)
  RETURN $$FALSE

  IF(#ShowOnlyMarked) THEN
     opt = $$GET_MARKED
  ELSE
     opt =  $$GET_ORDINAL
  END IF

   IF(GetNextRecord(@record, opt)) THEN RETURN
  IF(GetPreviousRecord(@record, opt)) THEN RETURN
  RETURN
END FUNCTION

' #################################
' #####  GetMarkedRecords ()  #####
' #################################
'
FUNCTION  GetMarkedRecords (@records[])
  SHARED RECORD RecordList[]

  REDIM records[]
  FOR i = 0 TO UBOUND(RecordList[])
    IF(RecordList[i].marked) THEN
      REDIM records[UBOUND(records[]) + 1]
      records[UBOUND(records[])] = i
    END IF
  NEXT i
END FUNCTION

' #############################
' #####  DestroyGrid ()  #####
' #############################
'
FUNCTION  DestroyGrid (grid)
  XuiGetKidArray(grid, #GetKidArray, @g, @parent, 0,0,0, @kids[])
  IF(kids[]) THEN
    FOR i = 1 TO UBOUND(kids[])
      XuiDestroy(kids[i], #Destroy, 0,0,0,0,0,0)
      NEXT i
  END IF
  XuiSendMessage(grid, #GetImage, @image,0,0,0,0,0)
  IF(image > 0) THEN
    XuiDestroy(image, #Destroy,0,0,0,0,0,0)
  END IF
  XuiDestroy(grid, #Destroy, 0,0,0,0,0,0)
END FUNCTION

'  ########################
'  #####  Confirm ()  #####
'  ########################
'
FUNCTION  Confirm (grid, message, v0, v1, v2, v3, r0, (r1, r1$, r1[], r1$[]))
   STATIC  designX,  designY,  designWidth,  designHeight
   STATIC  SUBADDR  sub[]
   STATIC  upperMessage
   STATIC  Confirm
   $Confirm      =   0  ' kid   0 grid type = Confirm
   $xlMessage    =   1  ' kid   1 grid type = XuiLabel
   $XuiLabel792  =   2  ' kid   2 grid type = XuiLabel
   $xpbYes       =   3  ' kid   3 grid type = XuiPushButton
   $xpbNo        =   4  ' kid   4 grid type = XuiPushButton
   $UpperKid     =   4  ' kid maximum

   IFZ sub[] THEN GOSUB Initialize
   IF XuiProcessMessage (grid, message, @v0, @v1, @v2, @v3, @r0, @r1, Confirm) THEN RETURN
   IF (message <= upperMessage) THEN GOSUB @sub[message]
   RETURN

  SUB Callback
     message = r1
     callback = message
     IF (message <= upperMessage) THEN GOSUB @sub[message]
  END SUB

  SUB Create
     IF (v0 <= 0) THEN v0 = 0
     IF (v1 <= 0) THEN v1 = 0
     IF (v2 <= 0) THEN v2 = designWidth
     IF (v3 <= 0) THEN v3 = designHeight
     XuiCreateGrid  (@grid, Confirm, @v0, @v1, @v2, @v3, r0, r1, &Confirm())
     XuiSendMessage ( grid, #SetGridName, 0, 0, 0, 0, 0, @"Confirm")
     XuiLabel       (@g, #Create, 0, 0, 324, 132, r0, grid)
     XuiSendMessage ( g, #SetCallback, grid, &Confirm(), -1, -1, $xlMessage, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xlMessage")
     XuiSendMessage ( g, #SetBorder, $$BorderValley, $$BorderValley, $$BorderNone, 0, 0, 0)
     XuiSendMessage ( g, #SetTexture, $$TextureNone, 0, 0, 0, 0, 0)

    XuiLabel       (@g, #Create, 0, 132, 324, 28, r0, grid)
     XuiSendMessage ( g, #SetCallback, grid, &Confirm(), -1, -1, $XuiLabel792, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"XuiLabel792")
     XuiSendMessage ( g, #SetBorder, $$BorderValley, $$BorderValley, $$BorderNone, 0, 0, 0)
     XuiPushButton  (@g, #Create, 52, 136, 104, 20, r0, grid)
     XuiSendMessage ( g, #SetCallback, grid, &Confirm(), -1, -1, $xpbYes, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xpbYes")
     XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"Yes")
     XuiPushButton  (@g, #Create, 164, 136, 104, 20, r0, grid)
     XuiSendMessage ( g, #SetCallback, grid, &Confirm(), -1, -1, $xpbNo, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xpbNo")
     XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"No")
     GOSUB Resize
  END SUB

  SUB CreateWindow
     IF (v0 == 0) THEN v0 = designX
     IF (v1 == 0) THEN v1 = designY
     IF (v2 <= 0) THEN v2 = designWidth
     IF (v3 <= 0) THEN v3 = designHeight
     XuiWindow (@window, #WindowCreate, v0, v1, v2, v3, r0, @r1$)
     v0 = 0 : v1 = 0 : r0 = window : ATTACH r1$ TO display$
     GOSUB Create
     r1 = 0 : ATTACH display$ TO r1$
     XuiWindow (window, #WindowRegister, grid, -1, v2, v3, @r0, @"Confirm")
  END SUB

  SUB GetSmallestSize
  END SUB

  SUB Redrawn
     XuiCallback (grid, #Redrawn, v0, v1, v2, v3, r0, r1)
  END SUB

  SUB Resize
  END SUB

  SUB Selection
  END SUB

  SUB Initialize
     XuiGetDefaultMessageFuncArray (@func[])
     XgrMessageNameToNumber (@"LastMessage", @upperMessage)
  '
     func[#Callback]           = &XuiCallback ()               ' disable to handle Callback messages internally
  ' func[#GetSmallestSize]    = 0                             ' enable to add internal GetSmallestSize routine
  ' func[#Resize]             = 0                             ' enable to add internal Resize routine
  '
     DIM sub[upperMessage]
  '  sub[#Callback]            = SUBADDRESS (Callback)         ' enable to handle Callback messages internally
     sub[#Create]              = SUBADDRESS (Create)           ' must be subroutine in this function
     sub[#CreateWindow]        = SUBADDRESS (CreateWindow)     ' must be subroutine in this function
  '  sub[#GetSmallestSize]     = SUBADDRESS (GetSmallestSize)  ' enable to add internal GetSmallestSize routine
     sub[#Redrawn]             = SUBADDRESS (Redrawn)          ' generate #Redrawn callback if appropriate
  '  sub[#Resize]              = SUBADDRESS (Resize)           ' enable to add internal Resize routine
     sub[#Selection]           = SUBADDRESS (Selection)        ' routes Selection callbacks to subroutine
  '
     IF sub[0] THEN PRINT "Confirm() : Initialize : error ::: (undefined message)"
     IF func[0] THEN PRINT "Confirm() : Initialize : error ::: (undefined message)"
     XuiRegisterGridType (@Confirm, "Confirm", &Confirm(), @func[], @sub[])
  '
  ' Don't remove the following 4 lines, or WindowFromFunction/WindowToFunction will not work
  '
     designX = 473
     designY = 208
     designWidth = 324
     designHeight = 160
  '
     gridType = Confirm
     XuiSetGridTypeProperty (gridType, @"x",                designX)
     XuiSetGridTypeProperty (gridType, @"y",                designY)
     XuiSetGridTypeProperty (gridType, @"width",            designWidth)
     XuiSetGridTypeProperty (gridType, @"height",           designHeight)
     XuiSetGridTypeProperty (gridType, @"maxWidth",         designWidth)
     XuiSetGridTypeProperty (gridType, @"maxHeight",        designHeight)
     XuiSetGridTypeProperty (gridType, @"minWidth",         designWidth)
     XuiSetGridTypeProperty (gridType, @"minHeight",        designHeight)
     XuiSetGridTypeProperty (gridType, @"can",              $$Focus OR $$Respond OR $$Callback)
     XuiSetGridTypeProperty (gridType, @"focusKid",         $xpbYes)
     IFZ message THEN RETURN
  END SUB
END FUNCTION

' ############################
' #####  ConfirmCode ()  #####
' ############################
'
FUNCTION  ConfirmCode (grid, message, v0, v1, v2, v3, kid, r1)
  STATIC XLONG response
   $Confirm      =   0  ' kid   0 grid type = Confirm
   $xlMessage    =   1  ' kid   1 grid type = XuiLabel
   $XuiLabel792  =   2  ' kid   2 grid type = XuiLabel
   $xpbYes       =   3  ' kid   3 grid type = XuiPushButton
   $xpbNo        =   4  ' kid   4 grid type = XuiPushButton
   $UpperKid     =   4  ' kid maximum

   IF (message == #Callback) THEN message = r1
'
   SELECT CASE message
      CASE #Selection      : GOSUB Selection
      CASE #CloseWindow : XuiSendMessage (grid, #HideWindow, 0, 0, 0, 0, 0, 0)
   END SELECT
   RETURN

  SUB Selection
     SELECT CASE kid
        CASE $xpbYes       :
        CASE $xpbNo        :
     END SELECT
  END SUB

END FUNCTION

'  ########################
'  #####  Message ()  #####
'  ########################
'
FUNCTION  Message (grid, message, v0, v1, v2, v3, r0, (r1, r1$, r1[], r1$[]))
   STATIC  designX,  designY,  designWidth,  designHeight
   STATIC  SUBADDR  sub[]
   STATIC  upperMessage
   STATIC  Message
   $Message      =   0  ' kid   0 grid type = Message
   $xlMessage    =   1  ' kid   1 grid type = XuiLabel
   $XuiLabel797  =   2  ' kid   2 grid type = XuiLabel
   $xpbOk        =   3  ' kid   3 grid type = XuiPushButton
   $UpperKid     =   3  ' kid maximum

   IFZ sub[] THEN GOSUB Initialize
   IF XuiProcessMessage (grid, message, @v0, @v1, @v2, @v3, @r0, @r1, Message) THEN RETURN
   IF (message <= upperMessage) THEN GOSUB @sub[message]
   RETURN

  SUB Callback
     message = r1
     callback = message
     IF (message <= upperMessage) THEN GOSUB @sub[message]
  END SUB

  SUB Create
     IF (v0 <= 0) THEN v0 = 0
     IF (v1 <= 0) THEN v1 = 0
     IF (v2 <= 0) THEN v2 = designWidth
     IF (v3 <= 0) THEN v3 = designHeight
     XuiCreateGrid  (@grid, Message, @v0, @v1, @v2, @v3, r0, r1, &Message())
     XuiSendMessage ( grid, #SetGridName, 0, 0, 0, 0, 0, @"Message")
     XuiLabel       (@g, #Create, 0, 0, 328, 132, r0, grid)
     XuiSendMessage ( g, #SetCallback, grid, &Message(), -1, -1, $xlMessage, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xlMessage")
     XuiSendMessage ( g, #SetBorder, $$BorderNone, $$BorderNone, $$BorderNone, 0, 0, 0)

     XuiSendMessage ( g, #SetTexture, $$TextureNone, 0, 0, 0, 0, 0)
    XuiLabel       (@g, #Create, 0, 132, 328, 36, r0, grid)
     XuiSendMessage ( g, #SetCallback, grid, &Message(), -1, -1, $XuiLabel797, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"XuiLabel797")
     XuiSendMessage ( g, #SetBorder, $$BorderValley, $$BorderValley, $$BorderNone, 0, 0, 0)
     XuiPushButton  (@g, #Create, 112, 140, 104, 20, r0, grid)
     XuiSendMessage ( g, #SetCallback, grid, &Message(), -1, -1, $xpbOk, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xpbOk")
     XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"Ok")
     GOSUB Resize
  END SUB

  SUB CreateWindow
     IF (v0 == 0) THEN v0 = designX
     IF (v1 == 0) THEN v1 = designY
     IF (v2 <= 0) THEN v2 = designWidth
     IF (v3 <= 0) THEN v3 = designHeight
     XuiWindow (@window, #WindowCreate, v0, v1, v2, v3, r0, @r1$)
     v0 = 0 : v1 = 0 : r0 = window : ATTACH r1$ TO display$
     GOSUB Create
     r1 = 0 : ATTACH display$ TO r1$
     XuiWindow (window, #WindowRegister, grid, -1, v2, v3, @r0, @"Message")
  END SUB

  SUB GetSmallestSize
  END SUB

  SUB Redrawn
     XuiCallback (grid, #Redrawn, v0, v1, v2, v3, r0, r1)
  END SUB

  SUB Resize
  END SUB

  SUB Selection
  END SUB

  SUB Initialize
     XuiGetDefaultMessageFuncArray (@func[])
     XgrMessageNameToNumber (@"LastMessage", @upperMessage)
  '
     func[#Callback]           = &XuiCallback ()               ' disable to handle Callback messages internally
  ' func[#GetSmallestSize]    = 0                             ' enable to add internal GetSmallestSize routine
  ' func[#Resize]             = 0                             ' enable to add internal Resize routine
  '
     DIM sub[upperMessage]
  '  sub[#Callback]            = SUBADDRESS (Callback)         ' enable to handle Callback messages internally
     sub[#Create]              = SUBADDRESS (Create)           ' must be subroutine in this function
     sub[#CreateWindow]        = SUBADDRESS (CreateWindow)     ' must be subroutine in this function
  '  sub[#GetSmallestSize]     = SUBADDRESS (GetSmallestSize)  ' enable to add internal GetSmallestSize routine
     sub[#Redrawn]             = SUBADDRESS (Redrawn)          ' generate #Redrawn callback if appropriate
  '  sub[#Resize]              = SUBADDRESS (Resize)           ' enable to add internal Resize routine
     sub[#Selection]           = SUBADDRESS (Selection)        ' routes Selection callbacks to subroutine
  '
     IF sub[0] THEN PRINT "Message() : Initialize : error ::: (undefined message)"
     IF func[0] THEN PRINT "Message() : Initialize : error ::: (undefined message)"
     XuiRegisterGridType (@Message, "Message", &Message(), @func[], @sub[])

     designX = 467
     designY = 349
     designWidth = 328
     designHeight = 168
  '
     gridType = Message
     XuiSetGridTypeProperty (gridType, @"x",                designX)
     XuiSetGridTypeProperty (gridType, @"y",                designY)
     XuiSetGridTypeProperty (gridType, @"width",            designWidth)
     XuiSetGridTypeProperty (gridType, @"height",           designHeight)
     XuiSetGridTypeProperty (gridType, @"maxWidth",         designWidth)
     XuiSetGridTypeProperty (gridType, @"maxHeight",        designHeight)
     XuiSetGridTypeProperty (gridType, @"minWidth",         designWidth)
     XuiSetGridTypeProperty (gridType, @"minHeight",        designHeight)
     XuiSetGridTypeProperty (gridType, @"can",              $$Focus OR $$Respond OR $$Callback)
     XuiSetGridTypeProperty (gridType, @"focusKid",         $xpbOk)
     IFZ message THEN RETURN
  END SUB
END FUNCTION

' ############################
' #####  MessageCode ()  #####
' ############################
'
FUNCTION  MessageCode (grid, message, v0, v1, v2, v3, kid, r1)
'
   $Message      =   0  ' kid   0 grid type = Message
   $xlMessage    =   1  ' kid   1 grid type = XuiLabel
   $XuiLabel797  =   2  ' kid   2 grid type = XuiLabel
   $xpbOk        =   3  ' kid   3 grid type = XuiPushButton
   $UpperKid     =   3  ' kid maximum

   IF (message == #Callback) THEN message = r1
'
   SELECT CASE message
      CASE #Selection      : GOSUB Selection
      CASE #CloseWindow : XuiSendMessage (grid, #HideWindow, 0, 0, 0, 0, 0, 0)
   END SELECT
   RETURN

  SUB Selection
     SELECT CASE kid
        CASE $Message      :
        CASE $xlMessage    :
        CASE $xpbOk        :
     END SELECT
  END SUB
END FUNCTION

'  #####################
'  #####  File ()  #####
'  #####################
'
FUNCTION  File (grid, message, v0, v1, v2, v3, r0, (r1, r1$, r1[], r1$[]))
   STATIC  designX,  designY,  designWidth,  designHeight
   STATIC  SUBADDR  sub[]
   STATIC  upperMessage
   STATIC  File

   $File        =   0  ' kid   0 grid type = File
   $XuiFile801  =   1  ' kid   1 grid type = XuiFile
   $UpperKid    =   1  ' kid maximum

   IFZ sub[] THEN GOSUB Initialize
   IF XuiProcessMessage (grid, message, @v0, @v1, @v2, @v3, @r0, @r1, File) THEN RETURN
   IF (message <= upperMessage) THEN GOSUB @sub[message]
   RETURN

  SUB Callback
     message = r1
     callback = message
     IF (message <= upperMessage) THEN GOSUB @sub[message]
  END SUB

  SUB Create
     IF (v0 <= 0) THEN v0 = 0
     IF (v1 <= 0) THEN v1 = 0
     IF (v2 <= 0) THEN v2 = designWidth
     IF (v3 <= 0) THEN v3 = designHeight
     XuiCreateGrid  (@grid, File, @v0, @v1, @v2, @v3, r0, r1, &File())
     XuiSendMessage ( grid, #SetGridName, 0, 0, 0, 0, 0, @"File")
     XuiFile        (@g, #Create, 0, 0, 532, 396, r0, grid)
     XuiSendMessage ( g, #SetCallback, grid, &File(), -1, -1, $XuiFile801, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"XuiFile801")
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 1, @"FileNameLabel")
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 2, @"FileNameText")
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 3, @"DirectoryLabel")
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 4, @"FilesLabel")
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 5, @"DirectoryBox")
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 6, @"FileBox")
     XuiSendMessage ( g, #SetTextArray, 0, 0, 0, 0, 6, @text$[])
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 7, @"EnterButton")
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 8, @"CancelButton")
     GOSUB Resize
  END SUB

  SUB CreateWindow
     IF (v0 == 0) THEN v0 = designX
     IF (v1 == 0) THEN v1 = designY
     IF (v2 <= 0) THEN v2 = designWidth
     IF (v3 <= 0) THEN v3 = designHeight
     XuiWindow (@window, #WindowCreate, v0, v1, v2, v3, r0, @r1$)
     v0 = 0 : v1 = 0 : r0 = window : ATTACH r1$ TO display$
     GOSUB Create
     r1 = 0 : ATTACH display$ TO r1$
     XuiWindow (window, #WindowRegister, grid, -1, v2, v3, @r0, @"File")
  END SUB

  SUB GetSmallestSize
  END SUB

  SUB Redrawn
     XuiCallback (grid, #Redrawn, v0, v1, v2, v3, r0, r1)
  END SUB

  SUB Resize
  END SUB

  SUB Selection
  END SUB

  SUB Initialize
     XuiGetDefaultMessageFuncArray (@func[])
     XgrMessageNameToNumber (@"LastMessage", @upperMessage)
  '
     func[#Callback]           = &XuiCallback ()               ' disable to handle Callback messages internally
  ' func[#GetSmallestSize]    = 0                             ' enable to add internal GetSmallestSize routine
  ' func[#Resize]             = 0                             ' enable to add internal Resize routine
  '
     DIM sub[upperMessage]
  '  sub[#Callback]            = SUBADDRESS (Callback)         ' enable to handle Callback messages internally
     sub[#Create]              = SUBADDRESS (Create)           ' must be subroutine in this function
     sub[#CreateWindow]        = SUBADDRESS (CreateWindow)     ' must be subroutine in this function
  '  sub[#GetSmallestSize]     = SUBADDRESS (GetSmallestSize)  ' enable to add internal GetSmallestSize routine
     sub[#Redrawn]             = SUBADDRESS (Redrawn)          ' generate #Redrawn callback if appropriate
  '  sub[#Resize]              = SUBADDRESS (Resize)           ' enable to add internal Resize routine
     sub[#Selection]           = SUBADDRESS (Selection)        ' routes Selection callbacks to subroutine
  '
     IF sub[0] THEN PRINT "File() : Initialize : error ::: (undefined message)"
     IF func[0] THEN PRINT "File() : Initialize : error ::: (undefined message)"
     XuiRegisterGridType (@File, "File", &File(), @func[], @sub[])

     designX = 504
     designY = 96
     designWidth = 532
     designHeight = 396
  '
     gridType = File
     XuiSetGridTypeProperty (gridType, @"x",                designX)
     XuiSetGridTypeProperty (gridType, @"y",                designY)
     XuiSetGridTypeProperty (gridType, @"width",            designWidth)
     XuiSetGridTypeProperty (gridType, @"height",           designHeight)
     XuiSetGridTypeProperty (gridType, @"maxWidth",         designWidth)
     XuiSetGridTypeProperty (gridType, @"maxHeight",        designHeight)
     XuiSetGridTypeProperty (gridType, @"minWidth",         designWidth)
     XuiSetGridTypeProperty (gridType, @"minHeight",        designHeight)
     XuiSetGridTypeProperty (gridType, @"can",              $$Focus OR $$Respond OR $$Callback OR $$TextSelection)
     XuiSetGridTypeProperty (gridType, @"focusKid",         $XuiFile801)
     XuiSetGridTypeProperty (gridType, @"inputTextString",  $XuiFile801)
     IFZ message THEN RETURN
  END SUB
  END FUNCTION

  ' #########################
  ' #####  FileCode ()  #####
  ' #########################
  '
  FUNCTION  FileCode (grid, message, v0, v1, v2, v3, kid, r1)
  '
    STATIC file$
    STATIC XLONG response

     $File        =   0  ' kid   0 grid type = File
     $XuiFile801  =   1  ' kid   1 grid type = XuiFile
     $UpperKid    =   1  ' kid maximum

     IF (message == #Callback) THEN message = r1
  '
    SELECT CASE message
      CASE #Selection     : GOSUB Selection
      CASE #CloseWindow : XuiSendMessage (grid, #HideWindow, 0, 0, 0, 0, 0, 0)
    END SELECT
    RETURN

    SUB Selection
    END SUB

END FUNCTION

' ############################
' #####  ShowMessage ()  #####
' ############################
'
FUNCTION  ShowMessage (@msg$)
  $xlMessage = 1

  IF(msg$ == "") THEN RETURN

  'Center the window
  CenterWindow(#Message)
  XuiSendMessage(#Message, #SetTextString, 0,0,0,0,$xlMessage, @msg$)
  XuiSendMessage(#Message, #DisplayWindow, 0,0,0,0,0,0)
  XuiSendMessage ( #Message, #SetGridProperties, -1, 0, 0, 0, 0, 0)
  XuiSendMessage ( #Message, #GetModalInfo, @v0, @v1, @v2, @v3, @kid, 0)
  XuiSendMessage ( #Message, #HideWindow, 0,0,0,0,0,0)
END FUNCTION

FUNCTION GetModeString (@mode$)
  SHARED MODE Mode

  mode$ = ""
   mode$ = "view: "
   SELECT CASE Mode.viewMode
      CASE $$VIEW_ALL :   mode$ = mode$ + "all"
      CASE $$VIEW_MARKED: mode$ = mode$ + "marked"
  END SELECT
   mode$ = mode$ + " | mark:"
   SELECT CASE Mode.markMode
      CASE $$MARK_APPEND :  mode$ = mode$ + "append"
      CASE $$MARK_REPLACE:  mode$ = mode$ + "replace"
  END SELECT
   mode$ = mode$ + " | find:"
   SELECT CASE Mode.findMode
      CASE $$FIND_ALL :  mode$ = mode$ + "all"
      CASE $$FIND_MARKED:  mode$ = mode$ + "marked"
  END SELECT
   mode$ = mode$ + " | export:"
   SELECT CASE Mode.exportMode
      CASE $$EXPORT_ALL :  mode$ = mode$ + "all"
      CASE $$EXPORT_MARKED:  mode$ = mode$ + "marked"
  END SELECT

END FUNCTION

'  ################################
'  #####  FieldProperties ()  #####
'  ################################
'
FUNCTION  FieldProperties (grid, message, v0, v1, v2, v3, r0, (r1, r1$, r1[], r1$[]))
   STATIC  designX,  designY,  designWidth,  designHeight
   STATIC  SUBADDR  sub[]
   STATIC  upperMessage
   STATIC  FieldProperties

   $FieldProperties  =   0  ' kid   0 grid type = FieldProperties
   $XuiLabel1000     =   1  ' kid   1 grid type = XuiLabel
   $XuiLabel1001     =   2  ' kid   2 grid type = XuiLabel
   $xbColorPicker    =   3  ' kid   3 grid type = XuiColor
   $xrbText          =   4  ' kid   4 grid type = XuiRadioButton
   $XuiLabel1004     =   5  ' kid   5 grid type = XuiLabel
   $xfFont           =   6  ' kid   6 grid type = XuiFont
   $xrbHighlight     =   7  ' kid   7 grid type = XuiRadioButton
   $xrbLowlight      =   8  ' kid   8 grid type = XuiRadioButton
   $xrbBackground    =   9  ' kid   9 grid type = XuiRadioButton
   $XuiLabel512      =  10  ' kid  10 grid type = XuiLabel
   $xlNone           =  11  ' kid  11 grid type = XuiRadioBox
   $xl3              =  12  ' kid  12 grid type = XuiRadioBox
   $xl6              =  13  ' kid  13 grid type = XuiRadioBox
   $xl9              =  14  ' kid  14 grid type = XuiRadioBox
   $xl12             =  15  ' kid  15 grid type = XuiRadioBox
   $xl15             =  16  ' kid  16 grid type = XuiRadioBox
   $xlBackColor      =  17  ' kid  17 grid type = XuiLabel
   $xlTextColor      =  18  ' kid  18 grid type = XuiLabel
   $xlHighColor      =  19  ' kid  19 grid type = XuiLabel
   $xl1              =  20  ' kid  20 grid type = XuiRadioBox
   $xl4              =  21  ' kid  21 grid type = XuiRadioBox
   $xl7              =  22  ' kid  22 grid type = XuiRadioBox
   $xl10             =  23  ' kid  23 grid type = XuiRadioBox
   $xl13             =  24  ' kid  24 grid type = XuiRadioBox
   $xl16             =  25  ' kid  25 grid type = XuiRadioBox
   $xl2              =  26  ' kid  26 grid type = XuiRadioBox
   $xl5              =  27  ' kid  27 grid type = XuiRadioBox
   $xl8              =  28  ' kid  28 grid type = XuiRadioBox
   $xl11             =  29  ' kid  29 grid type = XuiRadioBox
   $xl14             =  30  ' kid  30 grid type = XuiRadioBox
   $xlLowColor       =  31  ' kid  31 grid type = XuiLabel
   $UpperKid         =  31  ' kid maximum

   IFZ sub[] THEN GOSUB Initialize
   IF XuiProcessMessage (grid, message, @v0, @v1, @v2, @v3, @r0, @r1, FieldProperties) THEN RETURN
   IF (message <= upperMessage) THEN GOSUB @sub[message]
   RETURN

  SUB Callback
     message = r1
     callback = message
     IF (message <= upperMessage) THEN GOSUB @sub[message]
  END SUB
  '
  '
  ' *****  Create  *****  v0123 = xywh : r0 = window : r1 = parent
  '
  SUB Create
     IF (v0 <= 0) THEN v0 = 0
     IF (v1 <= 0) THEN v1 = 0
     IF (v2 <= 0) THEN v2 = designWidth
     IF (v3 <= 0) THEN v3 = designHeight
     XuiCreateGrid  (@grid, FieldProperties, @v0, @v1, @v2, @v3, r0, r1, &FieldProperties())
     XuiSendMessage ( grid, #SetGridName, 0, 0, 0, 0, 0, @"FieldProperties")
     XuiLabel       (@g, #Create, 0, 0, 96, 100, r0, grid)
     XuiSendMessage ( g, #SetCallback, grid, &FieldProperties(), -1, -1, $XuiLabel1000, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"XuiLabel1000")
     XuiLabel       (@g, #Create, 96, 0, 328, 100, r0, grid)
     XuiSendMessage ( g, #SetCallback, grid, &FieldProperties(), -1, -1, $XuiLabel1001, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"XuiLabel1001")
     XuiSendMessage ( g, #SetBorder, $$BorderValley, $$BorderValley, $$BorderNone, 0, 0, 0)
     XuiColor       (@g, #Create, 180, 8, 200, 80, r0, grid)
     XuiSendMessage ( g, #SetCallback, grid, &FieldProperties(), -1, -1, $xbColorPicker, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xbColorPicker")
     XuiSendMessage ( g, #SetColor, 54, $$Black, $$Black, $$White, 0, 0)
     XuiSendMessage ( g, #SetColorExtra, $$Cyan, 106, $$Black, $$White, 0, 0)
     XuiSendMessage ( g, #SetAlign, $$AlignUpperLeft, 0, -1, -1, 0, 0)
     XuiSendMessage ( g, #SetBorder, $$BorderLoLine1, $$BorderLoLine1, $$BorderNone, 0, 0, 0)
     XuiSendMessage ( g, #SetIndent, 6, 0, 4, 0, 0, 0)
     XuiSendMessage ( g, #SetTexture, $$TextureShadow, 0, 0, 0, 0, 0)
     XuiRadioButton (@g, #Create, 4, 28, 88, 20, r0, grid)
     XuiSendMessage ( g, #SetCallback, grid, &FieldProperties(), -1, -1, $xrbText, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xrbText")
     XuiSendMessage ( g, #SetTexture, $$TextureNone, 0, 0, 0, 0, 0)
     XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"Text")
     XuiLabel       (@g, #Create, 0, 100, 424, 248, r0, grid)
     XuiSendMessage ( g, #SetCallback, grid, &FieldProperties(), -1, -1, $XuiLabel1004, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"XuiLabel1004")
     XuiSendMessage ( g, #SetBorder, $$BorderValley, $$BorderValley, $$BorderNone, 0, 0, 0)
     XuiFont        (@g, #Create, 4, 104, 416, 240, r0, grid)
     XuiSendMessage ( g, #SetCallback, grid, &FieldProperties(), -1, -1, $xfFont, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xfFont")
     XuiSendMessage ( g, #SetBorder, $$BorderLower1, $$BorderLower1, $$BorderNone, 0, 0, 0)
    DIM text$[1]
    text$[0] = "The quick brown fox"
    text$[1] = "jumped over the lazy dog."
    XuiSendMessage ( g, #SetTextArray, 0, 0, 0, 0, 9, 0)

     XuiSendMessage ( g, #SetTextArray, 0, 0, 0, 0, 0, @text$[])
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 1, @"FontNameLabel")
     XuiSendMessage ( g, #SetTexture, $$TextureNone, 0, 0, 0, 1, 0)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 2, @"FontNameBox")
     DIM text$[22]
     text$[ 0] = "SystemDefault"
     text$[ 1] = "System"
     text$[ 2] = "Fixedsys"
     text$[ 3] = "Terminal"
     text$[ 4] = "MS Serif"
     text$[ 5] = "MS Sans Serif"
     text$[ 6] = "Courier"
     text$[ 7] = "Symbol"
     text$[ 8] = "Small Fonts"
     text$[ 9] = "Marlett"
     text$[10] = "Lucida Console"
     text$[11] = "Tahoma"
     text$[12] = "Arial"
     text$[13] = "Courier New"
     text$[14] = "Times New Roman"
     text$[15] = "Wingdings"
     text$[16] = "Symbol"
     text$[17] = "Arial Black"
     text$[18] = "Comic Sans MS"
     text$[19] = "Impact"
     text$[20] = "Trebuchet MS"
     text$[21] = "Verdana"
     text$[22] = "Webdings"
     XuiSendMessage ( g, #SetTextArray, 0, 0, 0, 0, 2, @text$[])
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 3, @"FontSizeLabel")
     XuiSendMessage ( g, #SetTexture, $$TextureNone, 0, 0, 0, 3, 0)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 4, @"FontSizeBox")
     XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 4, @"  8  point")
     DIM text$[15]
     text$[ 0] = "  8  point"
     text$[ 1] = " 10  point"
     text$[ 2] = " 12  point"
     text$[ 3] = " 14  point"
     text$[ 4] = " 16  point"
     text$[ 5] = " 18  point"
     text$[ 6] = " 20  point"
     text$[ 7] = " 22  point"
     text$[ 8] = " 24  point"
     text$[ 9] = " 26  point"
     text$[10] = " 28  point"
     text$[11] = " 30  point"
     text$[12] = " 32  point"
     text$[13] = " 34  point"
     text$[14] = " 36  point"
     text$[15] = " 38  point"
     XuiSendMessage ( g, #SetTextArray, 0, 0, 0, 0, 4, @text$[])
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 5, @"FontWeightLabel")
     XuiSendMessage ( g, #SetTexture, $$TextureNone, 0, 0, 0, 5, 0)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 6, @"FontWeightBox")
     XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 6, @"100  thin")
     DIM text$[8]
     text$[0] = "100  thin"
     text$[1] = "200  extra light"
     text$[2] = "300  light"
     text$[3] = "400  normal"
     text$[4] = "500  medium"
     text$[5] = "600  semi-bold"
     text$[6] = "700  bold"
     text$[7] = "800  extra bold"
     text$[8] = "900  heavy"
     XuiSendMessage ( g, #SetTextArray, 0, 0, 0, 0, 6, @text$[])
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 7, @"FontItalicLabel")
     XuiSendMessage ( g, #SetTexture, $$TextureNone, 0, 0, 0, 7, 0)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 8, @"FontItalicBox")
     XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 8, @"no")
     DIM text$[1]
     text$[0] = "no"
     text$[1] = "yes"
     XuiSendMessage ( g, #SetTextArray, 0, 0, 0, 0, 8, @text$[])
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 9, @"FontViewArea")
     XuiSendMessage ( g, #SetColor, $$White, $$Black, $$Black, $$White, 9, 0)
     XuiSendMessage ( g, #SetBorder, $$BorderRidge, $$BorderRidge, $$BorderNone, 0, 9, 0)
     XuiSendMessage ( g, #SetFont, 200, 400, 0, 0, 9, @"Terminal")
    XuiSendMessage ( g, #Update, 0,0,0,0,0,0)

     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 10, @"EnterButton")
     XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 10, @" use font ")
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 11, @"FontViewButton")
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 12, @"CancelButton")
     XuiSendMessage ( g, #SetTexture, $$TextureNone, 0, 0, 0, 12, 0)
     XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 12, @"")
     XuiRadioButton (@g, #Create, 4, 52, 88, 20, r0, grid)
     XuiSendMessage ( g, #SetCallback, grid, &FieldProperties(), -1, -1, $xrbHighlight, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xrbHighlight")
     XuiSendMessage ( g, #SetTexture, $$TextureNone, 0, 0, 0, 0, 0)
     XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"Higlight")
     XuiRadioButton (@g, #Create, 4, 76, 88, 20, r0, grid)
     XuiSendMessage ( g, #SetCallback, grid, &FieldProperties(), -1, -1, $xrbLowlight, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xrbLowlight")
     XuiSendMessage ( g, #SetTexture, $$TextureNone, 0, 0, 0, 0, 0)
     XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"Lowlight")
     XuiRadioButton (@g, #Create, 4, 4, 88, 20, r0, grid)
     XuiSendMessage ( g, #SetCallback, grid, &FieldProperties(), -1, -1, $xrbBackground, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xrbBackground")
     XuiSendMessage ( g, #SetTexture, $$TextureNone, 0, 0, 0, 0, 0)
     XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"Background")
     XuiLabel       (@g, #Create, 0, 348, 424, 104, r0, grid)
     XuiSendMessage ( g, #SetCallback, grid, &FieldProperties(), -1, -1, $XuiLabel512, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"XuiLabel512")
     XuiSendMessage ( g, #SetBorder, $$BorderValley, $$BorderValley, $$BorderNone, 0, 0, 0)
     XuiRadioBox    (@g, #Create, 16, 368, 56, 28, r0, grid)
     XuiSendMessage ( g, #SetStyle, 1,0,0,0,0,0)
     XuiSendMessage ( g, #SetCallback, grid, &FieldProperties(), -1, -1, $xlNone, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xlNone")
     XuiSendMessage ( g, #SetBorder, $$BorderNone, $$BorderNone, $$BorderNone, 0, 0, 0)
     XuiSendMessage ( g, #SetTexture, $$TextureNone, 0, 0, 0, 0, 0)
     XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"none")
     XuiRadioBox    (@g, #Create, 88, 352, 56, 28, r0, grid)
     XuiSendMessage ( g, #SetStyle, 1,0,0,0,0,0)
     XuiSendMessage ( g, #SetCallback, grid, &FieldProperties(), -1, -1, $xl3, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xl3")
     XuiSendMessage ( g, #SetBorder, $$BorderHiLine1, $$BorderHiLine1, $$BorderNone, 0, 0, 0)
     XuiRadioBox    (@g, #Create, 156, 352, 56, 28, r0, grid)
     XuiSendMessage ( g, #SetStyle, 1,0,0,0,0,0)
     XuiSendMessage ( g, #SetCallback, grid, &FieldProperties(), -1, -1, $xl6, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xl6")
     XuiSendMessage ( g, #SetBorder, $$BorderLoLine1, $$BorderLoLine1, $$BorderNone, 0, 0, 0)
     XuiRadioBox    (@g, #Create, 224, 352, 56, 28, r0, grid)
     XuiSendMessage ( g, #SetStyle, 1,0,0,0,0,0)
     XuiSendMessage ( g, #SetCallback, grid, &FieldProperties(), -1, -1, $xl9, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xl9")
     XuiSendMessage ( g, #SetBorder, $$BorderRaise1, $$BorderRaise1, $$BorderNone, 0, 0, 0)
     XuiRadioBox    (@g, #Create, 292, 352, 56, 28, r0, grid)
     XuiSendMessage ( g, #SetStyle, 1,0,0,0,0,0)
     XuiSendMessage ( g, #SetCallback, grid, &FieldProperties(), -1, -1, $xl12, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xl12")
     XuiSendMessage ( g, #SetBorder, $$BorderLower1, $$BorderLower1, $$BorderNone, 0, 0, 0)
     XuiRadioBox    (@g, #Create, 360, 352, 56, 28, r0, grid)
     XuiSendMessage ( g, #SetStyle, 1,0,0,0,0,0)
     XuiSendMessage ( g, #SetCallback, grid, &FieldProperties(), -1, -1, $xl15, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xl15")
     XuiSendMessage ( g, #SetBorder, $$BorderFrame, $$BorderFrame, $$BorderNone, 0, 0, 0)
     XuiLabel       (@g, #Create, 100, 4, 36, 20, r0, grid)
     XuiSendMessage ( g, #SetCallback, grid, &FieldProperties(), -1, -1, $xlBackColor, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xlBackColor")
     XuiSendMessage ( g, #SetBorder, $$BorderHiLine1, $$BorderHiLine1, $$BorderNone, 0, 0, 0)
     XuiLabel       (@g, #Create, 100, 28, 36, 20, r0, grid)
     XuiSendMessage ( g, #SetCallback, grid, &FieldProperties(), -1, -1, $xlTextColor, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xlTextColor")
     XuiSendMessage ( g, #SetBorder, $$BorderHiLine1, $$BorderHiLine1, $$BorderNone, 0, 0, 0)
     XuiLabel       (@g, #Create, 100, 52, 36, 20, r0, grid)
     XuiSendMessage ( g, #SetCallback, grid, &FieldProperties(), -1, -1, $xlHighColor, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xlHighColor")
     XuiSendMessage ( g, #SetBorder, $$BorderHiLine1, $$BorderHiLine1, $$BorderNone, 0, 0, 0)
     XuiRadioBox    (@g, #Create, 16, 404, 56, 28, r0, grid)
     XuiSendMessage ( g, #SetStyle, 1,0,0,0,0,0)
     XuiSendMessage ( g, #SetCallback, grid, &FieldProperties(), -1, -1, $xl1, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xl1")
     XuiSendMessage ( g, #SetBorder, $$BorderRidge, $$BorderRidge, $$BorderNone, 0, 0, 0)
     XuiRadioBox    (@g, #Create, 88, 384, 56, 28, r0, grid)
     XuiSendMessage ( g, #SetStyle, 1,0,0,0,0,0)
     XuiSendMessage ( g, #SetCallback, grid, &FieldProperties(), -1, -1, $xl4, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xl4")
     XuiSendMessage ( g, #SetBorder, $$BorderHiLine2, $$BorderHiLine2, $$BorderNone, 0, 0, 0)
     XuiRadioBox    (@g, #Create, 156, 384, 56, 28, r0, grid)
     XuiSendMessage ( g, #SetStyle, 1,0,0,0,0,0)
     XuiSendMessage ( g, #SetCallback, grid, &FieldProperties(), -1, -1, $xl7, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xl7")
     XuiSendMessage ( g, #SetBorder, $$BorderLoLine2, $$BorderLoLine2, $$BorderNone, 0, 0, 0)
     XuiRadioBox    (@g, #Create, 224, 384, 56, 28, r0, grid)
     XuiSendMessage ( g, #SetStyle, 1,0,0,0,0,0)
     XuiSendMessage ( g, #SetCallback, grid, &FieldProperties(), -1, -1, $xl10, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xl10")
     XuiSendMessage ( g, #SetBorder, $$BorderRaise2, $$BorderRaise2, $$BorderNone, 0, 0, 0)
     XuiRadioBox    (@g, #Create, 292, 384, 56, 28, r0, grid)
     XuiSendMessage ( g, #SetStyle, 1,0,0,0,0,0)
     XuiSendMessage ( g, #SetCallback, grid, &FieldProperties(), -1, -1, $xl13, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xl13")
     XuiSendMessage ( g, #SetBorder, $$BorderLower2, $$BorderLower2, $$BorderNone, 0, 0, 0)
     XuiRadioBox    (@g, #Create, 360, 384, 56, 28, r0, grid)
     XuiSendMessage ( g, #SetStyle, 1,0,0,0,0,0)
     XuiSendMessage ( g, #SetCallback, grid, &FieldProperties(), -1, -1, $xl16, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xl16")
     XuiSendMessage ( g, #SetBorder, $$BorderDrain, $$BorderDrain, $$BorderNone, 0, 0, 0)
     XuiRadioBox    (@g, #Create, 360, 416, 56, 28, r0, grid)
     XuiSendMessage ( g, #SetStyle, 1,0,0,0,0,0)
     XuiSendMessage ( g, #SetCallback, grid, &FieldProperties(), -1, -1, $xl2, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xl2")
     XuiSendMessage ( g, #SetBorder, $$BorderValley, $$BorderValley, $$BorderNone, 0, 0, 0)
     XuiRadioBox    (@g, #Create, 88, 416, 56, 28, r0, grid)
     XuiSendMessage ( g, #SetStyle, 1,0,0,0,0,0)
     XuiSendMessage ( g, #SetCallback, grid, &FieldProperties(), -1, -1, $xl5, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xl5")
     XuiSendMessage ( g, #SetBorder, $$BorderHiLine4, $$BorderHiLine4, $$BorderNone, 0, 0, 0)
     XuiRadioBox    (@g, #Create, 156, 416, 56, 28, r0, grid)
     XuiSendMessage ( g, #SetStyle, 1,0,0,0,0,0)
     XuiSendMessage ( g, #SetCallback, grid, &FieldProperties(), -1, -1, $xl8, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xl8")
     XuiSendMessage ( g, #SetBorder, $$BorderLoLine4, $$BorderLoLine4, $$BorderNone, 0, 0, 0)
     XuiRadioBox    (@g, #Create, 224, 416, 56, 28, r0, grid)
     XuiSendMessage ( g, #SetStyle, 1,0,0,0,0,0)
     XuiSendMessage ( g, #SetCallback, grid, &FieldProperties(), -1, -1, $xl11, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xl11")
     XuiSendMessage ( g, #SetBorder, $$BorderRaise4, $$BorderRaise4, $$BorderNone, 0, 0, 0)
     XuiRadioBox    (@g, #Create, 292, 416, 56, 28, r0, grid)
     XuiSendMessage ( g, #SetStyle, 1,0,0,0,0,0)
     XuiSendMessage ( g, #SetCallback, grid, &FieldProperties(), -1, -1, $xl14, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xl14")
     XuiSendMessage ( g, #SetBorder, $$BorderLower4, $$BorderLower4, $$BorderNone, 0, 0, 0)
     XuiLabel       (@g, #Create, 100, 76, 36, 20, r0, grid)
     XuiSendMessage ( g, #SetCallback, grid, &FieldProperties(), -1, -1, $xlLowColor, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xlLowColor")
     XuiSendMessage ( g, #SetBorder, $$BorderHiLine1, $$BorderHiLine1, $$BorderNone, 0, 0, 0)
     GOSUB Resize
  END SUB

  SUB CreateWindow
     IF (v0 == 0) THEN v0 = designX
     IF (v1 == 0) THEN v1 = designY
     IF (v2 <= 0) THEN v2 = designWidth
     IF (v3 <= 0) THEN v3 = designHeight
     XuiWindow (@window, #WindowCreate, v0, v1, v2, v3, r0, @r1$)
     v0 = 0 : v1 = 0 : r0 = window : ATTACH r1$ TO display$
     GOSUB Create
     r1 = 0 : ATTACH display$ TO r1$
     XuiWindow (window, #WindowRegister, grid, -1, v2, v3, @r0, @"FieldProperties")
  END SUB

  SUB GetSmallestSize
  END SUB

  SUB Redrawn
     XuiCallback (grid, #Redrawn, v0, v1, v2, v3, r0, r1)
  END SUB

  SUB Resize
  END SUB

  SUB Selection
  END SUB

  SUB Initialize
     XuiGetDefaultMessageFuncArray (@func[])
     XgrMessageNameToNumber (@"LastMessage", @upperMessage)
  '
     func[#Callback]           = &XuiCallback ()               ' disable to handle Callback messages internally
  ' func[#GetSmallestSize]    = 0                             ' enable to add internal GetSmallestSize routine
  ' func[#Resize]             = 0                             ' enable to add internal Resize routine
  '
     DIM sub[upperMessage]
  '  sub[#Callback]            = SUBADDRESS (Callback)         ' enable to handle Callback messages internally
     sub[#Create]              = SUBADDRESS (Create)           ' must be subroutine in this function
     sub[#CreateWindow]        = SUBADDRESS (CreateWindow)     ' must be subroutine in this function
  '  sub[#GetSmallestSize]     = SUBADDRESS (GetSmallestSize)  ' enable to add internal GetSmallestSize routine
     sub[#Redrawn]             = SUBADDRESS (Redrawn)          ' generate #Redrawn callback if appropriate
  '  sub[#Resize]              = SUBADDRESS (Resize)           ' enable to add internal Resize routine
     sub[#Selection]           = SUBADDRESS (Selection)        ' routes Selection callbacks to subroutine
  '
     IF sub[0] THEN PRINT "FieldProperties() : Initialize : error ::: (undefined message)"
     IF func[0] THEN PRINT "FieldProperties() : Initialize : error ::: (undefined message)"
     XuiRegisterGridType (@FieldProperties, "FieldProperties", &FieldProperties(), @func[], @sub[])
  '
  ' Don't remove the following 4 lines, or WindowFromFunction/WindowToFunction will not work
  '
     designX = 590
     designY = 68
     designWidth = 424
     designHeight = 452
  '
     gridType = FieldProperties
     XuiSetGridTypeProperty (gridType, @"x",                designX)
     XuiSetGridTypeProperty (gridType, @"y",                designY)
     XuiSetGridTypeProperty (gridType, @"width",            designWidth)
     XuiSetGridTypeProperty (gridType, @"height",           designHeight)
     XuiSetGridTypeProperty (gridType, @"maxWidth",         designWidth)
     XuiSetGridTypeProperty (gridType, @"maxHeight",        designHeight)
     XuiSetGridTypeProperty (gridType, @"minWidth",         designWidth)
     XuiSetGridTypeProperty (gridType, @"minHeight",        designHeight)
     XuiSetGridTypeProperty (gridType, @"can",              $$Focus OR $$Respond OR $$Callback OR $$TextSelection)
     XuiSetGridTypeProperty (gridType, @"focusKid",         $xrbText)
     XuiSetGridTypeProperty (gridType, @"inputTextString",  $xfFont)
     IFZ message THEN RETURN
  END SUB
END FUNCTION

' ####################################
' #####  FieldPropertiesCode ()  #####
' ####################################
'
FUNCTION  FieldPropertiesCode (grid, message, v0, v1, v2, v3, kid, r1)
  SHARED SEL_LIST SelList[]
   $FieldProperties  =   0  ' kid   0 grid type = FieldProperties
   $XuiLabel1000     =   1  ' kid   1 grid type = XuiLabel
   $XuiLabel1001     =   2  ' kid   2 grid type = XuiLabel
   $xbColorPicker    =   3  ' kid   3 grid type = XuiColor
   $xrbText          =   4  ' kid   4 grid type = XuiRadioButton
   $XuiLabel1004     =   5  ' kid   5 grid type = XuiLabel
   $xfFont           =   6  ' kid   6 grid type = XuiFont
   $xrbHighlight     =   7  ' kid   7 grid type = XuiRadioButton
   $xrbLowlight      =   8  ' kid   8 grid type = XuiRadioButton
   $xrbBackground    =   9  ' kid   9 grid type = XuiRadioButton
   $XuiLabel512      =  10  ' kid  10 grid type = XuiLabel
   $xlNone           =  11  ' kid  11 grid type = XuiRadioBox
   $xl3              =  12  ' kid  12 grid type = XuiRadioBox
   $xl6              =  13  ' kid  13 grid type = XuiRadioBox
   $xl9              =  14  ' kid  14 grid type = XuiRadioBox
   $xl12             =  15  ' kid  15 grid type = XuiRadioBox
   $xl15             =  16  ' kid  16 grid type = XuiRadioBox
   $xlBackColor      =  17  ' kid  17 grid type = XuiLabel
   $xlTextColor      =  18  ' kid  18 grid type = XuiLabel
   $xlHighColor      =  19  ' kid  19 grid type = XuiLabel
   $xl1              =  20  ' kid  20 grid type = XuiRadioBox
   $xl4              =  21  ' kid  21 grid type = XuiRadioBox
   $xl7              =  22  ' kid  22 grid type = XuiRadioBox
   $xl10             =  23  ' kid  23 grid type = XuiRadioBox
   $xl13             =  24  ' kid  24 grid type = XuiRadioBox
   $xl16             =  25  ' kid  25 grid type = XuiRadioBox
   $xl2              =  26  ' kid  26 grid type = XuiRadioBox
   $xl5              =  27  ' kid  27 grid type = XuiRadioBox
   $xl8              =  28  ' kid  28 grid type = XuiRadioBox
   $xl11             =  29  ' kid  29 grid type = XuiRadioBox
   $xl14             =  30  ' kid  30 grid type = XuiRadioBox
   $xlLowColor       =  31  ' kid  31 grid type = XuiLabel
   $UpperKid         =  31  ' kid maximum
  SHARED FIELD FieldList[]
  SHARED FIELD LabelList[]
  STATIC XLONG label
  STATIC XLONG selected_grid
  XLONG type

  selected_grid = #SelectedGrid
  IF(selected_grid == 0) THEN
    selected_grid = #CanvasGrid
  END IF
'
  IF (message == #Callback) THEN message = r1
'
  SELECT CASE message
    CASE #Notify        : GOSUB Notify
    CASE #Selection   : GOSUB Selection
    CASE #CloseWindow : DrawSelectionRectangle(@SelList[]) : XuiSendMessage (grid, #HideWindow, 0, 0, 0, 0, 0, 0)
  END SELECT
  RETURN

  SUB Selection
    IF(selected_grid == 0) THEN EXIT SUB
     SELECT CASE kid
        CASE $xbColorPicker    : GOSUB StartChange : GOSUB ChangeColor
        CASE $xrbText          : label = $xlTextColor
        CASE $xfFont           : GOSUB StartChange : GOSUB ChangeFont
        CASE $xrbHighlight     : label = $xlHighColor
        CASE $xrbLowlight      : label = $xlLowColor
        CASE $xrbBackground    : label = $xlBackColor
        CASE $xlNone           : GOSUB StartChange : GOSUB ChangeBorder
        CASE $xl3              : GOSUB StartChange : GOSUB ChangeBorder
        CASE $xl6              : GOSUB StartChange : GOSUB ChangeBorder
        CASE $xl9              : GOSUB StartChange : GOSUB ChangeBorder
        CASE $xl12             : GOSUB StartChange : GOSUB ChangeBorder
        CASE $xl15             : GOSUB StartChange : GOSUB ChangeBorder
        CASE $xl1              : GOSUB StartChange : GOSUB ChangeBorder
        CASE $xl4              : GOSUB StartChange : GOSUB ChangeBorder
        CASE $xl7              : GOSUB StartChange : GOSUB ChangeBorder
        CASE $xl10             : GOSUB StartChange : GOSUB ChangeBorder
        CASE $xl13             : GOSUB StartChange : GOSUB ChangeBorder
        CASE $xl16             : GOSUB StartChange : GOSUB ChangeBorder
        CASE $xl2              : GOSUB StartChange : GOSUB ChangeBorder
        CASE $xl5              : GOSUB StartChange : GOSUB ChangeBorder
        CASE $xl8              : GOSUB StartChange : GOSUB ChangeBorder
        CASE $xl11             : GOSUB StartChange : GOSUB ChangeBorder
        CASE $xl14             : GOSUB StartChange : GOSUB ChangeBorder
     END SELECT
  END SUB

  SUB StartChange
    IF(kid == $xfFont && v0 == -1) THEN RETURN
    IF(selected_grid == 0) THEN RETURN
    SELECT CASE TRUE
      CASE GetFieldByGrid(selected_grid, @index) : type = $$ENTRY
      CASE GetLabelByGrid(selected_grid, @index) : type = $$LABEL
      CASE selected_grid = #CanvasGrid           : type = -1
    END SELECT
  END SUB

  SUB EndChange
    XuiSendMessage(selected_grid, #RedrawGrid, 0,0,0,0,0,0)
    XuiSendMessage(#CanvasGrid, #Redraw,0,0,0,0,0,0)
    #LayoutModified = $$TRUE
  END SUB

  SUB ChangeBorder
    IF(v0 == $$FALSE) THEN EXIT SUB
    XuiSendMessage(grid, #GetBorder, @b1, @b2, @b3, @b4, kid, 0)
    XuiSendMessage(selected_grid, #SetBorder, b1, b2, b3, b4,0,0)
    SELECT CASE type
      CASE $$ENTRY:
        FieldList[index].border1 = b1
        FieldList[index].border2 = b2
        FieldList[index].border3 = b3
        FieldList[index].border4 = b4
      CASE $$LABEL:
        LabelList[index].border1 = b1
        LabelList[index].border2 = b2
        LabelList[index].border3 = b3
        LabelList[index].border4 = b4
    END SELECT
    GOSUB EndChange
  END SUB

  SUB ChangeFont
    IF(selected_grid == #CanvasGrid) THEN EXIT SUB

    XuiSendMessage(selected_grid, #SetFontNumber, v0, 0,0,0,0,0)
    XuiSendMessage(selected_grid, #GetFontMetrics, @maxWidth, @maxHeight, 0, 0, 0, @gap)

    XgrGetFontInfo(v0, @name$, @size, @weight, @italic, @angle)
    SELECT CASE type
      'TODO fix this for multi line fields
      CASE $$ENTRY:
        XuiSendMessage(selected_grid, #GetSize, 0, 0, @w, @h, 0, 0)
        FieldList[index].h = h
        FieldList[index].w = w
        FieldList[index].fontName = name$
        FieldList[index].fontSize = size
        FieldList[index].fontWeight = weight
        FieldList[index].fontItalic = italic
        FieldList[index].fontAngle = angle
      CASE $$LABEL:
        XuiSendMessage(selected_grid, #GetTextString, 0,0,0,0,0, @line$)
        XgrGetTextImageSize(v0, @line$, @dx, @dy, @width, @height, gap, 1)
        XgrSetGridPositionAndSize(selected_grid, LabelList[index].x, LabelList[index].y, width, height)
        LabelList[index].w = width + 3
        LabelList[index].h = height
        LabelList[index].fontName = name$
        LabelList[index].fontSize = size
        LabelList[index].fontWeight = weight
        LabelList[index].fontItalic = italic
        LabelList[index].fontAngle = angle
    END SELECT
    GOSUB EndChange
  END SUB

  SUB ChangeColor
    GOSUB SetColorIndicator

    XuiSendMessage(selected_grid, #GetColor,@back, @draw, @low, @high,0,0)
    SELECT CASE label
      CASE $xlBackColor:
        XuiSendMessage(selected_grid, #SetColor, v0, draw, low, high, 0,0)
      CASE $xlLowColor:
        XuiSendMessage(selected_grid, #SetColor, back, draw, v0, high, 0,0)
      CASE $xlHighColor:
        XuiSendMessage(selected_grid, #SetColor, back, draw, low, v0, 0,0)
      CASE $xlTextColor:
        XuiSendMessage(selected_grid, #SetColor, back, v0, low, high, 0,0)
    END SELECT
    XuiSendMessage(selected_grid, #GetColor,@back, @draw, @low, @high,0,0)
    SELECT CASE type
      CASE $$ENTRY:
        FieldList[index].backcolor = back
        FieldList[index].textcolor = draw
        FieldList[index].lowcolor = low
        FieldList[index].highcolor = high
      CASE $$LABEL:
        LabelList[index].backcolor = back
        LabelList[index].textcolor = draw
        LabelList[index].lowcolor = low
        LabelList[index].highcolor = high
    END SELECT
   GOSUB EndChange
  END SUB

  SUB SetColorIndicator
    XuiSendMessage(grid, #GetColor, @back, @draw, @low, @high, label, 0)
    XuiSendMessage(grid, #SetColor, v0, @draw, @low, @high, label, 0)
    XuiSendMessage(grid, #Redraw, 0,0,0,0,label, 0)
  END SUB

  SUB Notify
    IF(selected_grid == 0) THEN EXIT SUB
    XuiSendMessage(selected_grid, #GetColor,@back, @draw, @low, @high,0,0)
    XuiSendMessage(selected_grid, #GetFontNumber, @font, 0,0,0,0,0)

    XgrGetFontInfo(font, @name$, @size, @weight, @italic, @angle)
    XuiSendMessage(#FieldProperties, #GetGridNumber, @grid, 0,0,0, $xfFont, 0)
    XuiSendMessage(grid, #SetFontNumber, font, 0,0,0,9,0)
    DIM out$[1]
    out$[0] = name$ + " " + STRING$(size / 20) + " point"
    out$[1] = STRING$(weight) + " weight, "
    IF(italic) THEN
      out$[1] = out$[1] + "italics"
    ELSE
      out$[1] = out$[1] + "no italics"
    END IF
    XuiSendMessage(grid, #SetTextArray, 0,0,0,0, 9, @out$[])
    XuiSendMessage(grid, #Redraw, 0,0,0,0, 9,0)

    XuiSendMessage(#FieldProperties, #GetColor, @foo, @d, @l, @h, $xlBackColor,0)
    XuiSendMessage(#FieldProperties, #SetColor, back, d, l, h, $xlBackColor,0)
    XuiSendMessage(#FieldProperties, #Redraw, 0,0,0,0, $xlBackColor,0)

    XuiSendMessage(#FieldProperties, #GetColor, @foo, @d, @l, @h, $xlTextColor,0)
    XuiSendMessage(#FieldProperties, #SetColor, draw, d, l, h, $xlTextColor,0)
    XuiSendMessage(#FieldProperties, #Redraw, 0,0,0,0, $xlTextColor,0)

    XuiSendMessage(#FieldProperties, #GetColor, @foo, @d, @l, @h, $xlLowColor,0)
    XuiSendMessage(#FieldProperties, #SetColor, low, d, l, h, $xlLowColor,0)
    XuiSendMessage(#FieldProperties, #Redraw, 0,0,0,0, $xlLowColor,0)

    XuiSendMessage(#FieldProperties, #GetColor, @foo, @d, @l, @h, $xlHighColor,0)
    XuiSendMessage(#FieldProperties, #SetColor, high, d, l, h, $xlHighColor,0)
    XuiSendMessage(#FieldProperties, #Redraw, 0,0,0,0, $xlHighColor,0)
  END SUB

END FUNCTION

' ##########################
' #####  GetRecord ()  #####
' ##########################
'
' Get the index into RecordList given
' the index into RecordOrder
'
FUNCTION  GetRecord (record)
  SHARED XLONG RecordOrder[]

  IF(record > UBOUND(RecordOrder[])) THEN
    RETURN RecordOrder[UBOUND(RecordOrder[])]
  END IF
  RETURN RecordOrder[record]

END FUNCTION

' ##############################
' #####  GetOrderIndex ()  #####
' ##############################
'
' Get index into RecordOrder of the given record
'
FUNCTION  GetOrderIndex (record)
  SHARED XLONG RecordOrder[]

  FOR i = 0 TO UBOUND(RecordOrder[])
    IF(RecordOrder[i] == record) THEN
      RETURN i
    END IF
  NEXT i

  RETURN -1

END FUNCTION

'  #####################
'  #####  Sort ()  #####
'  #####################
'
FUNCTION  Sort (grid, message, v0, v1, v2, v3, r0, (r1, r1$, r1[], r1$[]))
   STATIC  designX,  designY,  designWidth,  designHeight
   STATIC  SUBADDR  sub[]
   STATIC  upperMessage
   STATIC  Sort

   $Sort              =   0  ' kid   0 grid type = Sort
   $XuiLabel788       =   1  ' kid   1 grid type = XuiLabel
   $XuiLabel789       =   2  ' kid   2 grid type = XuiLabel
   $xlFieldList       =   3  ' kid   3 grid type = XuiList
   $XuiLabel794       =   4  ' kid   4 grid type = XuiLabel
   $XuiLabel795       =   5  ' kid   5 grid type = XuiLabel
   $xpbSortAscending  =   6  ' kid   6 grid type = XuiRadioButton
   $xpbSortDecending  =   7  ' kid   7 grid type = XuiPushButton
   $xcbIgnoreSpaces   =   8  ' kid   8 grid type = XuiCheckBox
   $xcbIgnoreCase     =   9  ' kid   9 grid type = XuiCheckBox
   $XuiLabel800       =  10  ' kid  10 grid type = XuiLabel
   $xpbSort           =  11  ' kid  11 grid type = XuiPushButton
   $xpbCancel         =  12  ' kid  12 grid type = XuiPushButton
   $xpbHelp           =  13  ' kid  13 grid type = XuiPushButton
   $UpperKid          =  13  ' kid maximum

   IFZ sub[] THEN GOSUB Initialize
   IF XuiProcessMessage (grid, message, @v0, @v1, @v2, @v3, @r0, @r1, Sort) THEN RETURN
   IF (message <= upperMessage) THEN GOSUB @sub[message]
   RETURN

SUB Callback
   message = r1
   callback = message
   IF (message <= upperMessage) THEN GOSUB @sub[message]
END SUB

SUB Create
   IF (v0 <= 0) THEN v0 = 0
   IF (v1 <= 0) THEN v1 = 0
   IF (v2 <= 0) THEN v2 = designWidth
   IF (v3 <= 0) THEN v3 = designHeight
   XuiCreateGrid  (@grid, Sort, @v0, @v1, @v2, @v3, r0, r1, &Sort())
   XuiSendMessage ( grid, #SetGridName, 0, 0, 0, 0, 0, @"Sort")
   XuiLabel       (@g, #Create, 0, 0, 224, 264, r0, grid)
   XuiSendMessage ( g, #SetCallback, grid, &Sort(), -1, -1, $XuiLabel788, grid)
   XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"XuiLabel788")
   XuiSendMessage ( g, #SetBorder, $$BorderValley, $$BorderValley, $$BorderNone, 0, 0, 0)
   XuiLabel       (@g, #Create, 4, 4, 216, 20, r0, grid)
   XuiSendMessage ( g, #SetCallback, grid, &Sort(), -1, -1, $XuiLabel789, grid)
   XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"XuiLabel789")
   XuiSendMessage ( g, #SetBorder, $$BorderNone, $$BorderNone, $$BorderNone, 0, 0, 0)
   XuiSendMessage ( g, #SetTexture, $$TextureNone, 0, 0, 0, 0, 0)
   XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"Select Sort Field")
   XuiList        (@g, #Create, 4, 24, 212, 124, r0, grid)
   XuiSendMessage ( g, #SetCallback, grid, &Sort(), -1, -1, $xlFieldList, grid)
   XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xlFieldList")
   XuiSendMessage ( g, #SetStyle, 0, 0, 0, 0, 0, 0)
   XuiSendMessage ( g, #SetBorder, $$BorderLower1, $$BorderLower1, $$BorderNone, 0, 0, 0)
   XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 1, @"List")
   XuiSendMessage ( g, #SetColor, $$White, $$Black, $$Black, $$White, 1, 0)
   XuiSendMessage ( g, #SetColorExtra, $$Grey, $$BrightGreen, $$Black, $$White, 1, 0)
   XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 2, @"ScrollH")
   XuiSendMessage ( g, #SetStyle, 2, 0, 0, 0, 2, 0)
   XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 3, @"ScrollV")
   XuiSendMessage ( g, #SetStyle, 2, 0, 0, 0, 3, 0)
   XuiLabel       (@g, #Create, 4, 152, 212, 24, r0, grid)
   XuiSendMessage ( g, #SetCallback, grid, &Sort(), -1, -1, $XuiLabel794, grid)
   XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"XuiLabel794")
   XuiSendMessage ( g, #SetBorder, $$BorderValley, $$BorderValley, $$BorderNone, 0, 0, 0)
   XuiSendMessage ( g, #SetTexture, $$TextureNone, 0, 0, 0, 0, 0)
   XuiLabel       (@g, #Create, 4, 180, 116, 24, r0, grid)
   XuiSendMessage ( g, #SetCallback, grid, &Sort(), -1, -1, $XuiLabel795, grid)
   XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"XuiLabel795")
   XuiSendMessage ( g, #SetBorder, $$BorderNone, $$BorderNone, $$BorderNone, 0, 0, 0)
   XuiSendMessage ( g, #SetTexture, $$TextureNone, 0, 0, 0, 0, 0)
   XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"Sort Direction")
   XuiRadioButton (@g, #Create, 140, 180, 32, 28, r0, grid)
   XuiSendMessage ( g, #SetCallback, grid, &Sort(), -1, -1, $xpbSortAscending, grid)
   XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xpbSortAscending")
  XuiSendMessage ( g, #SetImage, 0,0,0,0,0, "." + $$PathSlash$ + "images" + $$PathSlash$ + "sort_a.bmp")
   XuiRadioButton  (@g, #Create, 180, 180, 32, 28, r0, grid)
   XuiSendMessage ( g, #SetCallback, grid, &Sort(), -1, -1, $xpbSortDecending, grid)
   XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xpbSortDecending")
   XuiSendMessage ( g, #SetImage, 0,0,0,0,0, "." + $$PathSlash$ + "images" + $$PathSlash$ + "sort_d.bmp")
  XuiCheckBox    (@g, #Create, 4, 216, 215, 20, r0, grid)
   XuiSendMessage ( g, #SetCallback, grid, &Sort(), -1, -1, $xcbIgnoreSpaces, grid)
   XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xcbIgnoreSpaces")
   XuiSendMessage ( g, #SetStyle, 3, 3, 0, 0, 0, 0)
   XuiSendMessage ( g, #SetBorder, $$BorderNone, $$BorderNone, $$BorderRaise1, 0, 0, 0)
   XuiSendMessage ( g, #SetTexture, $$TextureNone, 0, 0, 0, 0, 0)
   XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"Ignore Space/Punctuation")
   XuiCheckBox    (@g, #Create, 4, 236, 215, 20, r0, grid)
   XuiSendMessage ( g, #SetCallback, grid, &Sort(), -1, -1, $xcbIgnoreCase, grid)
   XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xcbIgnoreCase")
   XuiSendMessage ( g, #SetStyle, 3, 3, 0, 0, 0, 0)
   XuiSendMessage ( g, #SetBorder, $$BorderNone, $$BorderNone, $$BorderRaise1, 0, 0, 0)
   XuiSendMessage ( g, #SetTexture, $$TextureNone, 0, 0, 0, 0, 0)
   XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"Ignore Case")
   XuiLabel       (@g, #Create, 0, 264, 224, 36, r0, grid)
   XuiSendMessage ( g, #SetCallback, grid, &Sort(), -1, -1, $XuiLabel800, grid)
   XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"XuiLabel800")
   XuiSendMessage ( g, #SetBorder, $$BorderValley, $$BorderValley, $$BorderNone, 0, 0, 0)
   XuiPushButton  (@g, #Create, 12, 272, 60, 20, r0, grid)
   XuiSendMessage ( g, #SetCallback, grid, &Sort(), -1, -1, $xpbSort, grid)
   XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xpbSort")
   XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"Sort")
   XuiPushButton  (@g, #Create, 80, 272, 60, 20, r0, grid)
   XuiSendMessage ( g, #SetCallback, grid, &Sort(), -1, -1, $xpbCancel, grid)
   XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xpbCancel")
   XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"Cancel")
   XuiPushButton  (@g, #Create, 148, 272, 60, 20, r0, grid)
   XuiSendMessage ( g, #SetCallback, grid, &Sort(), -1, -1, $xpbHelp, grid)
   XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xpbHelp")
   XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"?")
   GOSUB Resize
END SUB

SUB CreateWindow
   IF (v0 == 0) THEN v0 = designX
   IF (v1 == 0) THEN v1 = designY
   IF (v2 <= 0) THEN v2 = designWidth
   IF (v3 <= 0) THEN v3 = designHeight
   XuiWindow (@window, #WindowCreate, v0, v1, v2, v3, r0, @r1$)
   v0 = 0 : v1 = 0 : r0 = window : ATTACH r1$ TO display$
   GOSUB Create
   r1 = 0 : ATTACH display$ TO r1$
   XuiWindow (window, #WindowRegister, grid, -1, v2, v3, @r0, @"Sort")
END SUB

SUB GetSmallestSize
END SUB

SUB Redrawn
   XuiCallback (grid, #Redrawn, v0, v1, v2, v3, r0, r1)
END SUB

SUB Resize
END SUB

SUB Selection
END SUB

SUB Initialize
   XuiGetDefaultMessageFuncArray (@func[])
   XgrMessageNameToNumber (@"LastMessage", @upperMessage)
'
   func[#Callback]           = &XuiCallback ()               ' disable to handle Callback messages internally
' func[#GetSmallestSize]    = 0                             ' enable to add internal GetSmallestSize routine
' func[#Resize]             = 0                             ' enable to add internal Resize routine
'
   DIM sub[upperMessage]
'  sub[#Callback]            = SUBADDRESS (Callback)         ' enable to handle Callback messages internally
   sub[#Create]              = SUBADDRESS (Create)           ' must be subroutine in this function
   sub[#CreateWindow]        = SUBADDRESS (CreateWindow)     ' must be subroutine in this function
'  sub[#GetSmallestSize]     = SUBADDRESS (GetSmallestSize)  ' enable to add internal GetSmallestSize routine
   sub[#Redrawn]             = SUBADDRESS (Redrawn)          ' generate #Redrawn callback if appropriate
'  sub[#Resize]              = SUBADDRESS (Resize)           ' enable to add internal Resize routine
   sub[#Selection]           = SUBADDRESS (Selection)        ' routes Selection callbacks to subroutine
'
   IF sub[0] THEN PRINT "Sort() : Initialize : error ::: (undefined message)"
   IF func[0] THEN PRINT "Sort() : Initialize : error ::: (undefined message)"
   XuiRegisterGridType (@Sort, "Sort", &Sort(), @func[], @sub[])

   designX = 758
   designY = 36
   designWidth = 224
   designHeight = 300
'
   gridType = Sort
   XuiSetGridTypeProperty (gridType, @"x",                designX)
   XuiSetGridTypeProperty (gridType, @"y",                designY)
   XuiSetGridTypeProperty (gridType, @"width",            designWidth)
   XuiSetGridTypeProperty (gridType, @"height",           designHeight)
   XuiSetGridTypeProperty (gridType, @"maxWidth",         designWidth)
   XuiSetGridTypeProperty (gridType, @"maxHeight",        designHeight)
   XuiSetGridTypeProperty (gridType, @"minWidth",         designWidth)
   XuiSetGridTypeProperty (gridType, @"minHeight",        designHeight)
   XuiSetGridTypeProperty (gridType, @"can",              $$Focus OR $$Respond OR $$Callback)
   XuiSetGridTypeProperty (gridType, @"focusKid",         $xlFieldList)
   IFZ message THEN RETURN
END SUB
END FUNCTION

' #########################
' #####  SortCode ()  #####
' #########################
'
FUNCTION  SortCode (grid, message, v0, v1, v2, v3, kid, r1)
  STATIC XLONG ignore_case
  STATIC XLONG ignore_space
  STATIC XLONG direction
  SHARED XLONG RecordOrder[]
  SHARED FIELD FieldList[]

   $Sort              =   0  ' kid   0 grid type = Sort
   $XuiLabel788       =   1  ' kid   1 grid type = XuiLabel
   $XuiLabel789       =   2  ' kid   2 grid type = XuiLabel
   $xlFieldList       =   3  ' kid   3 grid type = XuiList
   $XuiLabel794       =   4  ' kid   4 grid type = XuiLabel
   $XuiLabel795       =   5  ' kid   5 grid type = XuiLabel
   $xpbSortAscending  =   6  ' kid   6 grid type = XuiRadioButton
   $xpbSortDecending  =   7  ' kid   7 grid type = XuiPushButton
   $xcbIgnoreSpaces   =   8  ' kid   8 grid type = XuiCheckBox
   $xcbIgnoreCase     =   9  ' kid   9 grid type = XuiCheckBox
   $XuiLabel800       =  10  ' kid  10 grid type = XuiLabel
   $xpbSort           =  11  ' kid  11 grid type = XuiPushButton
   $xpbCancel         =  12  ' kid  12 grid type = XuiPushButton
   $xpbHelp           =  13  ' kid  13 grid type = XuiPushButton
   $UpperKid          =  13  ' kid maximum

   IF (message == #Callback) THEN message = r1

   SELECT CASE message
     CASE #Notify      : GOSUB Update
     CASE #Selection      : GOSUB Selection
     CASE #CloseWindow : XuiSendMessage (grid, #HideWindow, 0, 0, 0, 0, 0, 0)
   END SELECT
   RETURN

  SUB Selection
     SELECT CASE kid
        CASE $xlFieldList       : GOSUB SetSelectedField
        CASE $xpbSortAscending  : direction = $$SortIncreasing
        CASE $xpbSortDecending  : direction = $$SortDecreasing
        CASE $xcbIgnoreSpaces   : ignore_space = v0
        CASE $xcbIgnoreCase     : ignore_case = v0
        CASE $xpbSort           : GOSUB Sort
        CASE $xpbCancel         : XuiSendMessage(grid, #HideWindow, 0,0,0,0,0,0)
        CASE $xpbHelp           : Help()
     END SELECT
  END SUB

  SUB Sort
    XuiSendMessage(grid, #GetTextString, 0,0,0,0, 4, @line$)
    IF(line$) THEN
        GetFieldByName(@line$, @index)
      GetFieldData(index, @#Buff$[])
      ResetRecordOrder()
      SELECT CASE FieldList[index].type
          CASE $$FT_STRING_SINGLE, $$FT_STRING_MULTI:
          IF(ignore_case || ignore_space) THEN
            FOR i = 0 TO UBOUND(#Buff$[])
              IF(ignore_case) THEN
                #Buff$[i] = LCASE$(#Buff$[i])
              END IF
              IF(ignore_space) THEN
                Tokenize(#Buff$[i], @out$[], $$DELIMITERS$)
                XstStringArrayToString(@out$[], @line$)
                #Buff$[i] = line$
              END IF
            NEXT i
          END IF
          XstQuickSort(@#Buff$[], @RecordOrder[], 0, UBOUND(#Buff$[]), direction)
        CASE $$FT_INTEGER:
              REDIM #Buff$$[] : REDIM #Buff$$[UBOUND(#Buff$[])]
          FOR i = 0 TO UBOUND(#Buff$[])
            #Buff$$[i] = GIANT(#Buff$[i])
          NEXT i
          XstQuickSort(@#Buff$$[], @RecordOrder[], 0, UBOUND(#Buff$$[]), direction)
        CASE $$FT_REAL:
          REDIM #Buff#[] : REDIM #Buff#[UBOUND(#Buff$[])]
          FOR i = 0 TO UBOUND(#Buff$[])
            #Buff#[i] = DOUBLE(#Buff$[i])
          NEXT i
          XstQuickSort(@#Buff#[], @RecordOrder[], 0, UBOUND(#Buff#[]), direction)
        CASE $$FT_DATE:
          REDIM #Buff$$[] : REDIM #Buff$$[UBOUND(#Buff$[])]
          FOR i = 0 TO UBOUND(#Buff$[])
            Tokenize(#Buff$[i], @out$[], $$DATE_DELIMITERS$)
            XstDateAndTimeToFileTime(XLONG(out$[2]), XLONG(out$[0]), XLONG(out$[1]), 0, 0, 0, 0, 0, @time$$)
            #Buff$$[i] = time$$
          NEXT i
          XstQuickSort(@#Buff$$[], @RecordOrder[], 0, UBOUND(#Buff$$[]), direction)
      END SELECT

      #CurrentRecord = GetFirstRecord(@record, $$GET_ORDINAL)
      DisplayRecord(#CurrentRecord, $$TRUE)
      ListViewCode(#ListView, #Notify, $$FALSE,0,0,0,0,0)
      REDIM #Buff$[] : REDIM #Buff#[] : REDIM #Buff$$[] : REDIM #Buff[]
    END IF
  END SUB

  SUB SetSelectedField
     XuiSendMessage(grid, #GetTextArrayLine, v0, 0,0,0, kid, @line$)
    XuiSendMessage(grid, #SetTextString, 0,0,0,0, 4, @line$)
    XuiSendMessage(grid, #Redraw, 0,0,0,0, 4, 0)
  END SUB

  SUB Update
    GetFieldNames(@#Buff$[])
    XuiSendMessage(#Sort, #SetTextArray, 0,0,0,0, $xlFieldList, @#Buff$[])
    XuiSendMessage(#Sort, #Redraw, 0,0,0,0,$xlFieldList, 0)
  END SUB

END FUNCTION

' #############################
' #####  GetFieldData ()  #####
' #############################
'
' get field data that has been saved to StringData
'
FUNCTION  GetFieldData (index, @data$[])
  SHARED RECORD RecordList[]
  SHARED StringData$[]

  REDIM data$[]
  FOR i = 0 TO UBOUND(RecordList[])
    REDIM data$[i]
    data$[i] = StringData$[RecordList[i].first + index]
  NEXT i

END FUNCTION

' #################################
' #####  ResetRecordOrder ()  #####
' #################################
'
FUNCTION  ResetRecordOrder ()
   SHARED XLONG RecordOrder[]
  SHARED RECORD RecordList[]

  REDIM RecordOrder[UBOUND(RecordList[])]
  FOR i = 0 TO UBOUND(RecordOrder[])
    RecordOrder[i] = i
  NEXT i

END FUNCTION

' #################################
' #####  DeleteOrderIndex ()  #####
' #################################
'
FUNCTION  DeleteOrderIndex (record)
   SHARED XLONG RecordOrder[]

  index = GetOrderIndex(record)

  'Decrement all entries is RecordOrder
  'that are greater than record, because
  'they will all be shifted down one when the
  'record is deleted from RecordList
  FOR i = 0 TO UBOUND(RecordOrder[])
    IF(i != index) THEN
      IF(RecordOrder[i] > record) THEN
        DEC RecordOrder[i]
      END IF
    END IF
  NEXT i

  FOR i = index TO UBOUND(RecordOrder[]) - 1
    RecordOrder[i] = RecordOrder[i + 1]
  NEXT i

  REDIM RecordOrder[UBOUND(RecordOrder[]) - 1]
END FUNCTION

' ####################
' #####  Log ()  #####
' ####################
'
FUNCTION  Log (level, msg$)
  prefix$ = ""

  SELECT CASE level
    CASE $$LOG_DEBUG: GOSUB Debug
    CASE $$LOG_INFO:  GOSUB Info
    CASE $$LOG_ERROR: GOSUB Error
  END SELECT

  SUB Debug
    IF(#DEBUG) THEN
      prefix$ = "DEBUG: "
      msg$ = prefix$ + msg$
      PRINT(msg$)
    END IF
  END SUB

  SUB Info
    prefix$ = "INFO: "
    msg$ = prefix$ + msg$
    PRINT(msg$)
  END SUB

  SUB Error
    prefix$ = "!!ERROR: "
    msg$ = prefix$ + msg$
    PRINT(msg$)
  END SUB
END FUNCTION

'  ######################
'  #####  XFile ()  #####
'  ######################
'
FUNCTION  XFile (grid, message, v0, v1, v2, v3, r0, (r1, r1$, r1[], r1$[]))
   STATIC  designX,  designY,  designWidth,  designHeight
   STATIC  SUBADDR  sub[]
   STATIC  upperMessage
   STATIC  XFile
'
   $XFile     =   0  ' kid   0 grid type = XFile
   $xlLogo    =   1  ' kid   1 grid type = XuiLabel
   $xpbNew    =   2  ' kid   2 grid type = XuiPushButton
   $xpbOpen   =   3  ' kid   3 grid type = XuiPushButton
   $xpbQuit   =   4  ' kid   4 grid type = XuiPushButton
   $UpperKid  =   4  ' kid maximum
'
'
   IFZ sub[] THEN GOSUB Initialize
   IF XuiProcessMessage (grid, message, @v0, @v1, @v2, @v3, @r0, @r1, XFile) THEN RETURN
   IF (message <= upperMessage) THEN GOSUB @sub[message]
   RETURN

  SUB Callback
     message = r1
     callback = message
     IF (message <= upperMessage) THEN GOSUB @sub[message]
  END SUB

  SUB Create
     IF (v0 <= 0) THEN v0 = 0
     IF (v1 <= 0) THEN v1 = 0
     IF (v2 <= 0) THEN v2 = designWidth
     IF (v3 <= 0) THEN v3 = designHeight
     XuiCreateGrid  (@grid, XFile, @v0, @v1, @v2, @v3, r0, r1, &XFile())
     XuiSendMessage ( grid, #SetGridName, 0, 0, 0, 0, 0, @"XFile")
     XuiLabel       (@g, #Create, 0, 0, 216, 132, r0, grid)
     XuiSendMessage ( g, #SetCallback, grid, &XFile(), -1, -1, $xlLogo, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xlLogo")
     XuiSendMessage ( g, #SetBorder, $$BorderLoLine2, $$BorderLoLine2, $$BorderNone, 0, 0, 0)
    XuiSendMessage (g, #SetImage, 0,0,0,0,0, "." + $$PathSlash$ + "images" + $$PathSlash$ + "logo.bmp")
     XuiPushButton  (@g, #Create, 0, 132, 72, 60, r0, grid)
     XuiSendMessage ( g, #SetCallback, grid, &XFile(), -1, -1, $xpbNew, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xpbNew")
    XuiSendMessage (g, #SetImage, 0,0,0,0,0, "." + $$PathSlash$ + "images" + $$PathSlash$ + "big_new.bmp")
    XuiSendMessage (g, #SetHintString, 0,0,0,0,0, @"Create a new project")

     XuiPushButton  (@g, #Create, 72, 132, 72, 60, r0, grid)
     XuiSendMessage ( g, #SetCallback, grid, &XFile(), -1, -1, $xpbOpen, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xpbOpen")
    XuiSendMessage (g, #SetImage, 0,0,0,0,0, "." + $$PathSlash$ + "images" + $$PathSlash$ + "big_open.bmp")
    XuiSendMessage (g, #SetHintString, 0,0,0,0,0, @"Open a project")

     XuiPushButton  (@g, #Create, 144, 132, 72, 60, r0, grid)
     XuiSendMessage ( g, #SetCallback, grid, &XFile(), -1, -1, $xpbQuit, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xpbQuit")
    XuiSendMessage (g, #SetImage, 0,0,0,0,0, "." + $$PathSlash$ + "images" + $$PathSlash$ + "big_quit.bmp")
    XuiSendMessage (g, #SetHintString, 0,0,0,0,0, @"Quit")

     GOSUB Resize
  END SUB

  SUB CreateWindow
     IF (v0 == 0) THEN v0 = designX
     IF (v1 == 0) THEN v1 = designY
     IF (v2 <= 0) THEN v2 = designWidth
     IF (v3 <= 0) THEN v3 = designHeight
     XuiWindow (@window, #WindowCreate, v0, v1, v2, v3, r0, @r1$)
     v0 = 0 : v1 = 0 : r0 = window : ATTACH r1$ TO display$
     GOSUB Create
     r1 = 0 : ATTACH display$ TO r1$
     XuiWindow (window, #WindowRegister, grid, -1, v2, v3, @r0, @"XFile")
  END SUB

  SUB GetSmallestSize
  END SUB

  SUB Redrawn
     XuiCallback (grid, #Redrawn, v0, v1, v2, v3, r0, r1)
  END SUB

  SUB Resize
  END SUB

  SUB Selection
  END SUB

  SUB Initialize
     XuiGetDefaultMessageFuncArray (@func[])
     XgrMessageNameToNumber (@"LastMessage", @upperMessage)
  '
     func[#Callback]           = &XuiCallback ()               ' disable to handle Callback messages internally
  ' func[#GetSmallestSize]    = 0                             ' enable to add internal GetSmallestSize routine
  ' func[#Resize]             = 0                             ' enable to add internal Resize routine
  '
     DIM sub[upperMessage]
  '  sub[#Callback]            = SUBADDRESS (Callback)         ' enable to handle Callback messages internally
     sub[#Create]              = SUBADDRESS (Create)           ' must be subroutine in this function
     sub[#CreateWindow]        = SUBADDRESS (CreateWindow)     ' must be subroutine in this function
  '  sub[#GetSmallestSize]     = SUBADDRESS (GetSmallestSize)  ' enable to add internal GetSmallestSize routine
     sub[#Redrawn]             = SUBADDRESS (Redrawn)          ' generate #Redrawn callback if appropriate
  '  sub[#Resize]              = SUBADDRESS (Resize)           ' enable to add internal Resize routine
     sub[#Selection]           = SUBADDRESS (Selection)        ' routes Selection callbacks to subroutine
  '
     IF sub[0] THEN PRINT "XFile() : Initialize : error ::: (undefined message)"
     IF func[0] THEN PRINT "XFile() : Initialize : error ::: (undefined message)"
     XuiRegisterGridType (@XFile, "XFile", &XFile(), @func[], @sub[])

     designX = 398
     designY = 131
     designWidth = 216
     designHeight = 192
  '
     gridType = XFile
     XuiSetGridTypeProperty (gridType, @"x",                designX)
     XuiSetGridTypeProperty (gridType, @"y",                designY)
     XuiSetGridTypeProperty (gridType, @"width",            designWidth)
     XuiSetGridTypeProperty (gridType, @"height",           designHeight)
     XuiSetGridTypeProperty (gridType, @"maxWidth",         designWidth)
     XuiSetGridTypeProperty (gridType, @"maxHeight",        designHeight)
     XuiSetGridTypeProperty (gridType, @"minWidth",         designWidth)
     XuiSetGridTypeProperty (gridType, @"minHeight",        designHeight)
     XuiSetGridTypeProperty (gridType, @"can",              $$Focus OR $$Respond OR $$Callback)
     XuiSetGridTypeProperty (gridType, @"focusKid",         $xpbNew)
     IFZ message THEN RETURN
  END SUB
END FUNCTION

' ##########################
' #####  XFileCode ()  #####
' ##########################
'
FUNCTION  XFileCode (grid, message, v0, v1, v2, v3, kid, r1)
'
   $XFile     =   0  ' kid   0 grid type = XFile
   $xlLogo    =   1  ' kid   1 grid type = XuiLabel
   $xpbNew    =   2  ' kid   2 grid type = XuiPushButton
   $xpbOpen   =   3  ' kid   3 grid type = XuiPushButton
   $xpbQuit   =   4  ' kid   4 grid type = XuiPushButton
   $UpperKid  =   4  ' kid maximum
'
  IF (message == #Callback) THEN message = r1
'
  SELECT CASE message
    CASE #Selection      : GOSUB Selection
    CASE #CloseWindow : QuitProgram()
  END SELECT
  RETURN

  SUB Selection
    SELECT CASE kid
      CASE $xpbOpen   : GOSUB Open
      CASE $xpbNew    : GOSUB New
      CASE $xpbQuit   : QuitProgram()
    END SELECT
  END SUB

  SUB New
    IF(CreateProject()) THEN
      XuiSendMessage(grid, #HideWindow,0,0,0,0,0,0)
      #SplashActive = $$FALSE
			XuiSendMessage (#GeoFile, #DisplayWindow, 0, 0, 0, 0, 0, 0)
    END IF
  END SUB

  SUB Open
    IF(GetFilename(@file$, @attr)) THEN
      IF(OpenProject(@file$)) THEN
        XuiSendMessage(grid, #HideWindow, 0,0,0,0,0,0)
        #SplashActive = $$FALSE
				XuiSendMessage (#GeoFile, #DisplayWindow, 0, 0, 0, 0, 0, 0)
      END IF
    END IF
  END SUB
END FUNCTION

' #############################
' #####  AddFreeLabel ()  #####
' #############################
'
FUNCTION  AddFreeLabel ()
   SHARED FIELD LabelList[]

  XuiDialog("Enter label text", "", @foo, @message$)
  IF(foo == 2 || foo == 3 && message$ != "") THEN
    XuiSendMessage(#CanvasGrid, #GetFontMetrics, @font_width, @foo, @foo, @foo, 0, @foo)
    w = font_width * LEN(message$)
    index = AddLabel (message$, 10, 10, w, 20, $$FALSE, @foo)
    XuiSendMessage(#CanvasGrid, #Redraw, 0, 0,0,0,0,0)
  END IF
END FUNCTION

' ##########################
' #####  GlobalCEO ()  #####
' ##########################
'
FUNCTION  GlobalCEO (grid, message, v0, v1, v2, v3, r0, r1)

  IF(#StartingProgram == $$FALSE && message == #WindowResized) THEN
    XuiSendMessage(grid, #Redraw, 0,0,0,0,0,0)
    GOSUB ProcessResizeEvent
  END IF

  SELECT CASE grid
    CASE #GeoFileWin:
       GeoFileCEO(grid, message, v0, v1, v2, v3, @r0, r1)
    CASE #OrganizerWin:
       RETURN
    CASE #RecordWin:
       RETURN
  END SELECT

  'Eliminate smear by processing exactly one #WindowResized message
  'If you drag a window around, each drag even generates one WindowResized
  'event.  These are not processed until the mouse is released.
  SUB ProcessResizeEvent
    XgrMessagesPending(@count)

    IF(count > 0) THEN
      FOR i = 1 TO count
        XgrPeekMessage(@g, @msg, 0,0,0,0,0,0)
        IF(g == grid && msg == #WindowResized) THEN
           XgrDeleteMessages(1)
        ELSE
           XgrProcessMessages(1)
        END IF
      NEXT i
    END IF
  END SUB

  RETURN

END FUNCTION

' #############################
' #####  CreateLayout ()  #####
' #############################
'
FUNCTION  CreateLayout ()
   SHARED Layouts$[]
  SHARED FIELD FieldList[]
  SHARED FIELD LabelList[]

  XuiDialog("Enter layout name:", "", @kid, @message$)
  IF(kid == 2 || kid == 3) THEN
    message$ = message$ + ".frm"
     GOSUB CheckName
    GOSUB AddLayout
    upper = UBOUND(FieldList[])
    FOR i = 0 TO upper
      RemoveFromLayout(i, FieldList[i].grid_type)
    NEXT i
    upper = UBOUND(LabelList[])
    FOR i = 0 TO upper
         RemoveFromLayout(i, LabelList[i].grid_type)
    NEXT i
    OrganizerCode(#Organizer, #Notify,0,0,0,0,0,0)
    LayoutCode(#Layout, #Notify,0,0,0,0,0,0)
    LayoutCode(#Layout, #RedrawWindow,0,0,0,0,0,0)
    XuiSendMessage(#CanvasGrid, #Redraw,0,0,0,0,0,0)
  END IF

  SUB AddLayout
      upper = UBOUND(Layouts$[])
    REDIM Layouts$[upper + 1]
    Layouts$[upper + 1] = message$
    #CurrentLayout$ = message$
  END SUB

  SUB CheckName
      FOR i = 0 TO UBOUND(Layouts$[])
      IF(message$ == Layouts$[i]) THEN
        ShowMessage("Layout already exists!")
        CreateLayout()
      END IF
    NEXT i
  END SUB
END FUNCTION

' ###########################
' #####  GetLayouts ()  #####
' ###########################
'
FUNCTION  GetLayouts (@out$[])
   ext$ = "*.frm"

  IFZ(#CurrentProject$) THEN RETURN $$FALSE

  XstGetCurrentDirectory(@dir$)
  XstSetCurrentDirectory(@#CurrentProject$)
  XstGetFiles(@ext$, @out$[])
  XstSetCurrentDirectory(@dir$)
  RETURN $$TRUE

END FUNCTION

'  #######################
'  #####  Layout ()  #####
'  #######################
'
FUNCTION  Layout (grid, message, v0, v1, v2, v3, r0, (r1, r1$, r1[], r1$[]))
   STATIC  designX,  designY,  designWidth,  designHeight
   STATIC  SUBADDR  sub[]
   STATIC  upperMessage
   STATIC  Layout

   $Layout        =   0  ' kid   0 grid type = Layout
   $XuiLabel787   =   1  ' kid   1 grid type = XuiLabel
   $XuiLabel788   =   2  ' kid   2 grid type = XuiLabel
   $xpbOk         =   3  ' kid   3 grid type = XuiPushButton
   $xpbCancel     =   4  ' kid   4 grid type = XuiPushButton
   $xlLayoutList  =   5  ' kid   5 grid type = XuiList
   $UpperKid      =   5  ' kid maximum

   IFZ sub[] THEN GOSUB Initialize
   IF XuiProcessMessage (grid, message, @v0, @v1, @v2, @v3, @r0, @r1, Layout) THEN RETURN
   IF (message <= upperMessage) THEN GOSUB @sub[message]
   RETURN

  SUB Callback
     message = r1
     callback = message
     IF (message <= upperMessage) THEN GOSUB @sub[message]
  END SUB

  SUB Create
     IF (v0 <= 0) THEN v0 = 0
     IF (v1 <= 0) THEN v1 = 0
     IF (v2 <= 0) THEN v2 = designWidth
     IF (v3 <= 0) THEN v3 = designHeight
     XuiCreateGrid  (@grid, Layout, @v0, @v1, @v2, @v3, r0, r1, &Layout())
     XuiSendMessage ( grid, #SetGridName, 0, 0, 0, 0, 0, @"Layout")
     XuiLabel       (@g, #Create, 0, 0, 212, 196, r0, grid)
     XuiSendMessage ( g, #SetCallback, grid, &Layout(), -1, -1, $XuiLabel787, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"XuiLabel787")
     XuiSendMessage ( g, #SetBorder, $$BorderValley, $$BorderValley, $$BorderNone, 0, 0, 0)
     XuiLabel       (@g, #Create, 0, 196, 212, 44, r0, grid)
     XuiSendMessage ( g, #SetCallback, grid, &Layout(), -1, -1, $XuiLabel788, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"XuiLabel788")
     XuiSendMessage ( g, #SetBorder, $$BorderValley, $$BorderValley, $$BorderNone, 0, 0, 0)
     XuiPushButton  (@g, #Create, 16, 208, 80, 20, r0, grid)
     XuiSendMessage ( g, #SetCallback, grid, &Layout(), -1, -1, $xpbOk, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xpbOk")
     XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"Load")
     XuiPushButton  (@g, #Create, 112, 208, 80, 20, r0, grid)
     XuiSendMessage ( g, #SetCallback, grid, &Layout(), -1, -1, $xpbCancel, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xpbCancel")
     XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"Cancel")
     XuiList        (@g, #Create, 4, 4, 204, 188, r0, grid)
     XuiSendMessage ( g, #SetCallback, grid, &Layout(), -1, -1, $xlLayoutList, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xlLayoutList")
     XuiSendMessage ( g, #SetStyle, 0, 0, 0, 0, 0, 0)
     XuiSendMessage ( g, #SetBorder, $$BorderLower1, $$BorderLower1, $$BorderNone, 0, 0, 0)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 1, @"List")
     XuiSendMessage ( g, #SetColor, $$White, $$Black, $$Black, $$White, 1, 0)
     XuiSendMessage ( g, #SetColorExtra, $$Grey, $$BrightGreen, $$Black, $$White, 1, 0)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 2, @"ScrollH")
     XuiSendMessage ( g, #SetStyle, 2, 0, 0, 0, 2, 0)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 3, @"ScrollV")
     XuiSendMessage ( g, #SetStyle, 2, 0, 0, 0, 3, 0)
     GOSUB Resize
  END SUB

  SUB CreateWindow
     IF (v0 == 0) THEN v0 = designX
     IF (v1 == 0) THEN v1 = designY
     IF (v2 <= 0) THEN v2 = designWidth
     IF (v3 <= 0) THEN v3 = designHeight
     XuiWindow (@window, #WindowCreate, v0, v1, v2, v3, r0, @r1$)
     v0 = 0 : v1 = 0 : r0 = window : ATTACH r1$ TO display$
     GOSUB Create
     r1 = 0 : ATTACH display$ TO r1$
     XuiWindow (window, #WindowRegister, grid, -1, v2, v3, @r0, @"Layout")
  END SUB

  SUB GetSmallestSize
  END SUB

  SUB Redrawn
    XuiCallback (grid, #Redrawn, v0, v1, v2, v3, r0, r1)
  END SUB

  SUB Resize
  END SUB

  SUB Selection
  END SUB

  SUB Initialize
     XuiGetDefaultMessageFuncArray (@func[])
     XgrMessageNameToNumber (@"LastMessage", @upperMessage)
  '
     func[#Callback]           = &XuiCallback ()               ' disable to handle Callback messages internally
  ' func[#GetSmallestSize]    = 0                             ' enable to add internal GetSmallestSize routine
  ' func[#Resize]             = 0                             ' enable to add internal Resize routine
  '
     DIM sub[upperMessage]
  '  sub[#Callback]            = SUBADDRESS (Callback)         ' enable to handle Callback messages internally
     sub[#Create]              = SUBADDRESS (Create)           ' must be subroutine in this function
     sub[#CreateWindow]        = SUBADDRESS (CreateWindow)     ' must be subroutine in this function
  '  sub[#GetSmallestSize]     = SUBADDRESS (GetSmallestSize)  ' enable to add internal GetSmallestSize routine
     sub[#Redrawn]             = SUBADDRESS (Redrawn)          ' generate #Redrawn callback if appropriate
  '  sub[#Resize]              = SUBADDRESS (Resize)           ' enable to add internal Resize routine
     sub[#Selection]           = SUBADDRESS (Selection)        ' routes Selection callbacks to subroutine
  '
     IF sub[0] THEN PRINT "Layout() : Initialize : error ::: (undefined message)"
     IF func[0] THEN PRINT "Layout() : Initialize : error ::: (undefined message)"
     XuiRegisterGridType (@Layout, "Layout", &Layout(), @func[], @sub[])
  '
  ' Don't remove the following 4 lines, or WindowFromFunction/WindowToFunction will not work
  '
     designX = 713
     designY = 102
     designWidth = 212
     designHeight = 240
  '
     gridType = Layout
     XuiSetGridTypeProperty (gridType, @"x",                designX)
     XuiSetGridTypeProperty (gridType, @"y",                designY)
     XuiSetGridTypeProperty (gridType, @"width",            designWidth)
     XuiSetGridTypeProperty (gridType, @"height",           designHeight)
     XuiSetGridTypeProperty (gridType, @"maxWidth",         designWidth)
     XuiSetGridTypeProperty (gridType, @"maxHeight",        designHeight)
     XuiSetGridTypeProperty (gridType, @"minWidth",         designWidth)
     XuiSetGridTypeProperty (gridType, @"minHeight",        designHeight)
     XuiSetGridTypeProperty (gridType, @"can",              $$Focus OR $$Respond OR $$Callback)
     XuiSetGridTypeProperty (gridType, @"focusKid",         $xpbOk)
     IFZ message THEN RETURN
  END SUB
END FUNCTION

' ###########################
' #####  LayoutCode ()  #####
' ###########################
'
'
FUNCTION  LayoutCode (grid, message, v0, v1, v2, v3, kid, r1)
  SHARED Layouts$[]

   $Layout        =   0  ' kid   0 grid type = Layout
   $XuiLabel787   =   1  ' kid   1 grid type = XuiLabel
   $XuiLabel788   =   2  ' kid   2 grid type = XuiLabel
   $xpbOk         =   3  ' kid   3 grid type = XuiPushButton
   $xpbCancel     =   4  ' kid   4 grid type = XuiPushButton
   $xlLayoutList  =   5  ' kid   5 grid type = XuiList
   $UpperKid      =   5  ' kid maximum
'
   IF (message == #Callback) THEN message = r1
'
   SELECT CASE message
    CASE #Notify      : GOSUB Update
      CASE #Selection      : GOSUB Selection
      CASE #CloseWindow : XuiSendMessage (grid, #HideWindow, 0, 0, 0, 0, 0, 0)
   END SELECT
   RETURN

  SUB Selection
     SELECT CASE kid
        CASE $xpbOk         :
        XuiSendMessage(grid, #GetValue, 0, 0, 0, @v3, $xlLayoutList, 0)
        v0 = v3
        GOSUB LoadLayout
        CASE $xpbCancel     :XuiSendMessage(grid, #HideWindow,0,0,0,0,0,0)
        CASE $xlLayoutList  :GOSUB LoadLayout
     END SELECT
  END SUB

  SUB Update
     XuiSendMessage(#Layout, #SetTextArray, 0,0,0,0, $xlLayoutList, @Layouts$[])
  END SUB

  SUB LoadLayout
    IF(#LayoutModified) THEN
      IF(AskYesNo("The current layout has been modified.\nWould you like to save it?")) THEN
        SaveLayout(#CurrentLayout$)
      END IF
    END IF
    ClearCanvas()
     XuiSendMessage(grid, #GetTextArrayLine, v0, 0,0,0,$xlLayoutList, @line$)
    LoadLayout(line$, $$FALSE, $$TRUE)
    DisplayRecord(#CurrentRecord, $$TRUE)
  END SUB

END FUNCTION

'
'
'	#########################
'	#####  ListView ()  #####
'	#########################
'
'	"Anatomy of Grid Functions" in the GuiDesigner Programmer Guide
'	describes the operation and modification of grid functions in detail.
'
'	WindowFromFunction and/or WindowToFunction may not work, or may not generate the desired results if you:
'		* Modify the kid constant definition improperly.
'		* Modify the code in the Create subroutine improperly.
'		* Imbed blank or comment lines in the Create subroutine.
'		* Remove the GOSUB Resize line in the Create subroutine (comment out is okay).
'		* Imbed special purpose code in the Create subroutine before the GOSUB Resize line.
'		* Delete any of the four lines that assign values to designX, designY, designWidth, designHeight.
'
FUNCTION  ListView (grid, message, v0, v1, v2, v3, r0, (r1, r1$, r1[], r1$[]))
	STATIC  designX,  designY,  designWidth,  designHeight
	STATIC  SUBADDR  sub[]
	STATIC  upperMessage
	STATIC  ListView
'
	$ListView  =   0  ' kid   0 grid type = ListView
  $Fieldlist =   1
	$Listview  =   2 ' kid   1 grid type = XuiList
	$UpperKid  =   2  ' kid maximum
'
'
	IFZ sub[] THEN GOSUB Initialize
'	XuiReportMessage (grid, message, v0, v1, v2, v3, r0, r1)
	IF XuiProcessMessage (grid, message, @v0, @v1, @v2, @v3, @r0, @r1, ListView) THEN RETURN
	IF (message <= upperMessage) THEN GOSUB @sub[message]
	RETURN
  '
  '
  ' *****  Callback  *****  message = Callback : r1 = original message
  '
  SUB Callback
    message = r1
    callback = message
    IF (message <= upperMessage) THEN GOSUB @sub[message]
  END SUB
  '
  '
  ' *****  Create  *****  v0123 = xywh : r0 = window : r1 = parent
  '
  SUB Create
    IF (v0 <= 0) THEN v0 = 0
    IF (v1 <= 0) THEN v1 = 0
    IF (v2 <= 0) THEN v2 = designWidth
    IF (v3 <= 0) THEN v3 = designHeight
    XuiCreateGrid  (@grid, ListView, @v0, @v1, @v2, @v3, r0, r1, &ListView())
    XuiSendMessage ( grid, #SetGridName, 0, 0, 0, 0, 0, @"ListView")
    XuiDropBox     (@g, #Create, 0, 0, 300, 24, r0, grid)
    XuiSendMessage ( g, #SetCallback, grid, &ListView(), -1, -1, $Fieldlist, grid)
    XuiSendMessage ( g, #SetFont, 240, 1000, 0, 0, 0, @"MS Sans Serif")
    XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"Fieldlist")
    XuiSendMessage ( g, #SetStyle, 0, 0, 0, 0, 0, 0)
    XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 1, @"TextLine")
    XuiSendMessage ( g, #SetFont, 240, 1000, 0, 0, 1, @"MS Sans Serif")
    XuiSendMessage ( g, #SetBorder, $$BorderRidge, $$BorderRidge, $$BorderRidge, 0, 1, 0)
    XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 2, @"PressButton")
    XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 3, @"Fieldlist")
    XuiSendMessage ( g, #SetFont, 240, 1000, 0, 0, 3, @"MS Sans Serif")
    XuiList        (@g, #Create, 0, 24, 300, 300, r0, grid)
    XuiSendMessage ( g, #SetCallback, grid, &ListView(), -1, -1, $Listview, grid)
    XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"Listview")
    XuiSendMessage ( g, #SetStyle, 0, 0, 0, 0, 0, 0)
    XuiSendMessage ( g, #SetBorder, $$BorderLoLine1, $$BorderLoLine1, $$BorderNone, 0, 0, 0)
    XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 1, @"List")
    XuiSendMessage ( g, #SetColor, $$White, $$Black, $$Black, $$White, 1, 0)
    XuiSendMessage ( g, #SetColorExtra, $$Grey, $$Green, $$Black, $$White, 1, 0)
    XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 2, @"ScrollH")
    XuiSendMessage ( g, #SetStyle, 2, 0, 0, 0, 2, 0)
    XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 3, @"ScrollV")
    XuiSendMessage ( g, #SetStyle, 2, 0, 0, 0, 3, 0)
    GOSUB Resize
  END SUB
  '
  '
  ' *****  CreateWindow  *****  v0123 = xywh : r0 = windowType : r1$ = display$
  '
  SUB CreateWindow
    IF (v0 == 0) THEN v0 = designX
    IF (v1 == 0) THEN v1 = designY
    IF (v2 <= 0) THEN v2 = designWidth
    IF (v3 <= 0) THEN v3 = designHeight
    XuiWindow (@window, #WindowCreate, v0, v1, v2, v3, r0, @r1$)
    v0 = 0 : v1 = 0 : r0 = window : ATTACH r1$ TO display$
    GOSUB Create
    r1 = 0 : ATTACH display$ TO r1$
    XuiWindow (window, #WindowRegister, grid, -1, v2, v3, @r0, @"ListView")
  END SUB
  '
  '
  ' *****  GetSmallestSize  *****  see "Anatomy of Grid Functions"
  '
  SUB GetSmallestSize
  END SUB
  '
  '
  ' *****  Redrawn  *****  see "Anatomy of Grid Functions"
  '
  SUB Redrawn
    XuiCallback (grid, #Redrawn, v0, v1, v2, v3, r0, r1)
  END SUB
  '
  '
  ' *****  Resize  *****  see "Anatomy of Grid Functions"
  '
  SUB Resize
  END SUB
  '
  '
  ' *****  Selection  *****  see "Anatomy of Grid Functions"
  '
  SUB Selection
  END SUB
  '
  '
  ' *****  Initialize  *****  see "Anatomy of Grid Functions"
  '
  SUB Initialize
    XuiGetDefaultMessageFuncArray (@func[])
    XgrMessageNameToNumber (@"LastMessage", @upperMessage)
  '
    func[#Callback]           = &XuiCallback ()               ' disable to handle Callback messages internally
  ' func[#GetSmallestSize]    = 0                             ' enable to add internal GetSmallestSize routine
  ' func[#Resize]             = 0                             ' enable to add internal Resize routine
  '
    DIM sub[upperMessage]
  '	sub[#Callback]            = SUBADDRESS (Callback)         ' enable to handle Callback messages internally
    sub[#Create]              = SUBADDRESS (Create)           ' must be subroutine in this function
    sub[#CreateWindow]        = SUBADDRESS (CreateWindow)     ' must be subroutine in this function
  '	sub[#GetSmallestSize]     = SUBADDRESS (GetSmallestSize)  ' enable to add internal GetSmallestSize routine
    sub[#Redrawn]             = SUBADDRESS (Redrawn)          ' generate #Redrawn callback if appropriate
  '	sub[#Resize]              = SUBADDRESS (Resize)           ' enable to add internal Resize routine
    sub[#Selection]           = SUBADDRESS (Selection)        ' routes Selection callbacks to subroutine
  '
    IF sub[0] THEN PRINT "ListView() : Initialize : error ::: (undefined message)"
    IF func[0] THEN PRINT "ListView() : Initialize : error ::: (undefined message)"
    XuiRegisterGridType (@ListView, "ListView", &ListView(), @func[], @sub[])
  '
  ' Don't remove the following 4 lines, or WindowFromFunction/WindowToFunction will not work
  '
    designX = 526
    designY = 152
    designWidth = 300
    designHeight = 324
  '
    gridType = ListView
    XuiSetGridTypeProperty (gridType, @"x",                designX)
    XuiSetGridTypeProperty (gridType, @"y",                designY)
    XuiSetGridTypeProperty (gridType, @"width",            designWidth)
    XuiSetGridTypeProperty (gridType, @"height",           designHeight)
    XuiSetGridTypeProperty (gridType, @"maxWidth",         designWidth)
    XuiSetGridTypeProperty (gridType, @"maxHeight",        designHeight)
    XuiSetGridTypeProperty (gridType, @"minWidth",         designWidth)
    XuiSetGridTypeProperty (gridType, @"minHeight",        designHeight)
    XuiSetGridTypeProperty (gridType, @"can",              $$Focus OR $$Respond OR $$Callback)
    XuiSetGridTypeProperty (gridType, @"focusKid",         $Listview)
    IFZ message THEN RETURN
  END SUB
END FUNCTION

'
'
' #############################
' #####  ListViewCode ()  #####
' #############################
'

FUNCTION  ListViewCode (grid, message, v0, v1, v2, v3, kid, r1)
  SHARED RECORD RecordList[]
  SHARED StringData$[]
  STATIC XLONG Record[]

	$ListView  =   0  ' kid   0 grid type = ListView
  $Fieldlist =   1
	$Listview  =   2 ' kid   1 grid type = XuiList
	$UpperKid  =   2  ' kid maximum
'
	'XuiReportMessage (grid, message, v0, v1, v2, v3, kid, r1)
	IF (message == #Callback) THEN message = r1
'
	SELECT CASE message
    CASE #Notify      : GOSUB Update
		CASE #Selection		: GOSUB Selection   	' most common callback message
		CASE #CloseWindow	: XuiSendMessage (grid, #HideWindow, 0, 0, 0, 0, 0, 0)
	END SELECT
	RETURN
  '
  '
  ' *****  Selection  *****
  '
  SUB Selection
    SELECT CASE kid
      CASE $ListView  :
      CASE $Fieldlist : GOSUB HandleField
      CASE $Listview  : GOSUB HandleListSelection
    END SELECT
  END SUB

  SUB HandleField
    IFZ(RecordList[]) THEN EXIT SUB
    ctr = 0
    XuiSendMessage(#ListView, #GetTextString, 0, 0,0,0, $Fieldlist, @field$)
    IFZ(GetFieldByName(field$, @index)) THEN RETURN
    'Get all field values for the requested field
    REDIM #Buff$[]
    REDIM #Buff$[UBOUND(RecordList[])]
    REDIM Record[UBOUND(RecordList[])]
    IF(#ShowOnlyMarked) THEN
      record = GetFirstRecord(0, $$GET_MARKED)
    ELSE
      record = GetFirstRecord(0, $$GET_ORDINAL)
    END IF
    first = RecordList[record].first
    #Buff$[ctr] = StringData$[first + index]
    Record[ctr] = record
    DO
      INC ctr
      IF(#ShowOnlyMarked) THEN
        record = GetNextRecord(GetOrderIndex(record), $$GET_MARKED)
      ELSE
        record = GetNextRecord(GetOrderIndex(record), $$GET_ORDINAL)
      END IF
      IF(record == -1) THEN EXIT DO
      first = RecordList[record].first
      #Buff$[ctr] = StringData$[first + index]
      Record[ctr] = record
    LOOP

    XuiSendMessage(#ListView, #SetTextArray, 0,0,0,0, $Listview, @#Buff$[])
    XuiSendMessage(#ListView, #SetWindowTitle, 0,0,0,0,0, @field$)
    XuiSendMessage(#ListView, #Redraw, 0,0,0,0,$Listview, 0)
  END SUB

  SUB HandleListSelection
    record = Record[v0]
    DisplayRecord(record, $$TRUE)
  END SUB

  SUB Update
    IF(v0) THEN
      GetFieldNames(@#Buff$[])
      XuiSendMessage(#ListView, #SetTextArray, 0,0,0,0, $Fieldlist, @#Buff$[])
      XuiSendMessage(#ListView, #Redraw, 0,0,0,0,$Fieldlist, 0)
    END IF
    GOSUB HandleField
  END SUB
END FUNCTION

' #################################
' #####  RemoveFromLayout ()  #####
' #################################
'
FUNCTION  RemoveFromLayout (index, type)
  SHARED FIELD LabelList[]
  SHARED FIELD FieldList[]
  SHARED SEL_LIST SelList[]

  SELECT CASE type
    CASE $$ENTRY: GOSUB RemoveField
    CASE $$LABEL: GOSUB RemoveLabel
    CASE $$IMAGE: GOSUB RemoveField
    CASE $$STATIC_IMAGE: GOSUB RemoveLabel
  END SELECT

  SUB RemoveField
    IF(SelList[]) THEN REDIM SelList[]
    FieldList[index].visible = $$FALSE
    FieldList[index].in_layout = $$FALSE
    XuiSendMessage(FieldList[index].grid, #Disable, 0,0,0,0,0,0)
  END SUB

  SUB RemoveLabel
    LabelList[index].visible = $$FALSE
    LabelList[index].in_layout = $$FALSE
    XuiSendMessage(LabelList[index].grid, #Disable, 0,0,0,0,0,0)
  END SUB

END FUNCTION

' ############################
' #####  AddToLayout ()  #####
' ############################
'
FUNCTION  AddToLayout (index, type)
  SHARED FIELD LabelList[]
  SHARED FIELD FieldList[]

  SELECT CASE type
    CASE $$ENTRY: GOSUB AddField
    CASE $$LABEL: GOSUB AddLabel
    CASE $$IMAGE: GOSUB AddLabel
    CASE $$STATIC_IMAGE: GOSUB AddLabel
  END SELECT

  SUB AddField
    XuiSendMessage(FieldList[index].grid, #Enable, 0,0,0,0,0,0)
    FieldList[index].visible = $$TRUE
    FieldList[index].in_layout = $$TRUE
    IFZ(IsFieldVisible(FieldList[index])) THEN
      Log($$LOG_DEBUG, "Making field " + FieldList[index].name + " visible")
			MakeFieldVisible(index, type)
    END IF
  END SUB

  SUB AddLabel
    XuiSendMessage(LabelList[index].grid, #Enable, 0,0,0,0,0,0)
    LabelList[index].visible = $$TRUE
    LabelList[index].in_layout = $$TRUE
    IFZ(IsFieldVisible(LabelList[index])) THEN
      Log($$LOG_DEBUG, "Making label " + LabelList[index].name + " visible")
			MakeFieldVisible(index, type)
    END IF
  END SUB

END FUNCTION

' ############################
' #####  ClearCanvas ()  #####
' ############################
'
FUNCTION  ClearCanvas ()
  SHARED FIELD FieldList[]
  SHARED FIELD LabelList[]
  SHARED SEL_LIST SelList[]
  UBYTE image[]

  'Destroy grids
   FOR i = 0 TO UBOUND(FieldList[])
     DestroyGrid(FieldList[i].grid)
   NEXT i

   FOR i = 0 TO UBOUND(LabelList[])
     DestroyGrid(LabelList[i].grid)
   NEXT i

   IF(#BackgroundImage$) THEN
     SetBackgroundImage("", $$FALSE)
   END IF

   REDIM SelList[]

   'Clean the canvas
   XuiSendMessage(#CanvasGrid, #SetColor, #CANVAS_COLOR, $$White, $$Black, $$White,0,0)
   XgrClearGrid(#CanvasGridBuffer, #CANVAS_COLOR)
   XgrRefreshGrid(#CanvasGrid)
   XuiSendMessage(#GeoFile, #Redraw, 0,0,0,0,0,0)
END FUNCTION

'  ########################
'  #####  Arrange ()  #####
'  ########################
'
FUNCTION  Arrange (grid, message, v0, v1, v2, v3, r0, (r1, r1$, r1[], r1$[]))
   STATIC  designX,  designY,  designWidth,  designHeight
   STATIC  SUBADDR  sub[]
   STATIC  upperMessage
   STATIC  Arrange
'
   $Arrange                =   0  ' kid   0 grid type = Arrange
   $XuiLabel787            =   1  ' kid   1 grid type = XuiLabel
   $XuiLabel788            =   2  ' kid   2 grid type = XuiLabel
   $xpbApply               =   3  ' kid   3 grid type = XuiPushButton
   $xpbCancel              =   4  ' kid   4 grid type = XuiPushButton
   $xpbHelp                =   5  ' kid   5 grid type = XuiPushButton
   $XuiLabel792            =   6  ' kid   6 grid type = XuiLabel
   $xrbAlignLeft           =   7  ' kid   8 grid type = XuiRadioButton
   $xrbSpaceLeft           =   8  ' kid   9 grid type = XuiRadioButton
   $xrbAlignCenter         =   9  ' kid  10 grid type = XuiRadioButton
   $xrbSpaceCenter         =  10  ' kid  11 grid type = XuiRadioButton
   $xrbAlignRight          =  11  ' kid  12 grid type = XuiRadioButton
   $xrbSpaceRight          =  12  ' kid  13 grid type = XuiRadioButton
   $xrbAlignLeftEdge       =  13  ' kid  14 grid type = XuiRadioButton
   $xrbSpaceLeftRight      =  14  ' kid  15 grid type = XuiRadioButton
   $xrbAlignTop            =  15  ' kid  16 grid type = XuiRadioButton
   $xrbAlignTopCenter      =  16  ' kid  17 grid type = XuiRadioButton
   $xrbAlignBottom         =  17  ' kid  18 grid type = XuiRadioButton
   $xrbAlignBottomCenter   =  18  ' kid  19 grid type = XuiRadioButton
   $xrbSpaceBottom         =  19  ' kid  20 grid type = XuiRadioButton
  $xrbSpaceTopCenter      =  20  ' kid  22 grid type = XuiRadioButton
   $xrbSpaceTop            =  21  ' kid  21 grid type = XuiRadioButton
   $xrbSpaceSpaceToBottom  =  22  ' kid  23 grid type = XuiRadioButton
   $UpperKid               =  22  ' kid maximum
'
'
   IFZ sub[] THEN GOSUB Initialize
   IF XuiProcessMessage (grid, message, @v0, @v1, @v2, @v3, @r0, @r1, Arrange) THEN RETURN
   IF (message <= upperMessage) THEN GOSUB @sub[message]
   RETURN

  SUB Callback
     message = r1
     callback = message
     IF (message <= upperMessage) THEN GOSUB @sub[message]
  END SUB

  SUB Create
     IF (v0 <= 0) THEN v0 = 0
     IF (v1 <= 0) THEN v1 = 0
     IF (v2 <= 0) THEN v2 = designWidth
     IF (v3 <= 0) THEN v3 = designHeight
     XuiCreateGrid  (@grid, Arrange, @v0, @v1, @v2, @v3, r0, r1, &Arrange())
     XuiSendMessage ( grid, #SetGridName, 0, 0, 0, 0, 0, @"Arrange")
     XuiLabel       (@g, #Create, 0, 0, 312, 200, r0, grid)
     XuiSendMessage ( g, #SetCallback, grid, &Arrange(), -1, -1, $XuiLabel787, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"XuiLabel787")
     XuiSendMessage ( g, #SetBorder, $$BorderValley, $$BorderValley, $$BorderNone, 0, 0, 0)
     XuiLabel       (@g, #Create, 0, 200, 312, 48, r0, grid)
     XuiSendMessage ( g, #SetCallback, grid, &Arrange(), -1, -1, $XuiLabel788, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"XuiLabel788")
     XuiSendMessage ( g, #SetBorder, $$BorderValley, $$BorderValley, $$BorderNone, 0, 0, 0)
     XuiPushButton  (@g, #Create, 24, 212, 80, 20, r0, grid)
     XuiSendMessage ( g, #SetCallback, grid, &Arrange(), -1, -1, $xpbApply, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xpbApply")
     XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"Apply")
     XuiPushButton  (@g, #Create, 132, 212, 80, 20, r0, grid)
     XuiSendMessage ( g, #SetCallback, grid, &Arrange(), -1, -1, $xpbCancel, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xpbCancel")
     XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"Close")
     XuiPushButton  (@g, #Create, 256, 212, 28, 20, r0, grid)
     XuiSendMessage ( g, #SetCallback, grid, &Arrange(), -1, -1, $xpbHelp, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xpbHelp")
     XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"?")
     XuiLabel       (@g, #Create, 8, 20, 296, 152, r0, grid)
     XuiSendMessage ( g, #SetCallback, grid, &Arrange(), -1, -1, $XuiLabel792, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"XuiLabel792")
     XuiSendMessage ( g, #SetBorder, $$BorderLoLine1, $$BorderLoLine1, $$BorderNone, 0, 0, 0)

    XuiRadioButton (@g, #Create, 16, 40, 64, 28, r0, grid)
     XuiSendMessage ( g, #SetCallback, grid, &Arrange(), -1, -1, $xrbAlignLeft, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xrbAlignLeft")
    XuiSendMessage ( g, #SetImage, 0, 0, 0, 0, 0, "." + $$PathSlash$ + "images" + $$PathSlash$ + "align_left.bmp")
    XuiSendMessage ( g, #SetHintString, 0,0,0,0,0, @"Align all with left-most")

    XuiRadioButton (@g, #Create, 80, 40, 64, 28, r0, grid)
     XuiSendMessage ( g, #SetCallback, grid, &Arrange(), -1, -1, $xrbSpaceLeft, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xrbSpaceLeft")
    XuiSendMessage ( g, #SetImage, 0, 0, 0, 0, 0, "." + $$PathSlash$ + "images" + $$PathSlash$ + "space_left.bmp")
    XuiSendMessage ( g, #SetHintString, 0,0,0,0,0, @"Space by left-edge to left-edge")

     XuiRadioButton (@g, #Create, 16, 68, 64, 28, r0, grid)
     XuiSendMessage ( g, #SetCallback, grid, &Arrange(), -1, -1, $xrbAlignCenter, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xrbAlignCenter")
    XuiSendMessage ( g, #SetImage, 0, 0, 0, 0, 0, "." + $$PathSlash$ + "images" + $$PathSlash$ + "align_cent_top.bmp")
    XuiSendMessage ( g, #SetHintString, 0,0,0,0,0, @"Center all with top-most")

     XuiRadioButton (@g, #Create, 80, 68, 64, 28, r0, grid)
     XuiSendMessage ( g, #SetCallback, grid, &Arrange(), -1, -1, $xrbSpaceCenter, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xrbSpaceCenter")
    XuiSendMessage ( g, #SetImage, 0, 0, 0, 0, 0, "." + $$PathSlash$ + "images" + $$PathSlash$ + "space_cent_h.bmp")
    XuiSendMessage ( g, #SetHintString, 0,0,0,0,0, @"Space all by center of left-most")

    XuiRadioButton (@g, #Create, 16, 96, 64, 28, r0, grid)
     XuiSendMessage ( g, #SetCallback, grid, &Arrange(), -1, -1, $xrbAlignRight, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xrbAlignRight")
    XuiSendMessage ( g, #SetImage, 0, 0, 0, 0, 0, "." + $$PathSlash$ + "images" + $$PathSlash$ + "align_right.bmp")
    XuiSendMessage ( g, #SetHintString, 0,0,0,0,0, @"Align all with right-most")

     XuiRadioButton (@g, #Create, 80, 96, 64, 28, r0, grid)
     XuiSendMessage ( g, #SetCallback, grid, &Arrange(), -1, -1, $xrbSpaceRight, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xrbSpaceRight")
    XuiSendMessage ( g, #SetImage, 0, 0, 0, 0, 0, "." + $$PathSlash$ + "images" + $$PathSlash$ + "space_right.bmp")
    XuiSendMessage ( g, #SetHintString, 0,0,0,0,0, @"Space by right-edge to right-edge")

     XuiRadioButton (@g, #Create, 16, 124, 64, 28, r0, grid)
     XuiSendMessage ( g, #SetCallback, grid, &Arrange(), -1, -1, $xrbAlignLeftEdge, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xrbAlignLeftEdge")
    XuiSendMessage ( g, #SetImage, 0, 0, 0, 0, 0, "." + $$PathSlash$ + "images" + $$PathSlash$ + "align_cent_bot.bmp")
    XuiSendMessage ( g, #SetHintString, 0,0,0,0,0, @"Center all with bottom-most")

     XuiRadioButton (@g, #Create, 80, 124, 64, 28, r0, grid)
     XuiSendMessage ( g, #SetCallback, grid, &Arrange(), -1, -1, $xrbSpaceLeftRight, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xrbSpaceLeftRight")
    XuiSendMessage ( g, #SetImage, 0, 0, 0, 0, 0, "." + $$PathSlash$ + "images" + $$PathSlash$ + "space_l_r_h.bmp")
    XuiSendMessage ( g, #SetHintString, 0,0,0,0,0, @"Space all by left edge to leftmost right edge")

     XuiRadioButton (@g, #Create, 168, 35, 32, 60, r0, grid)
     XuiSendMessage ( g, #SetCallback, grid, &Arrange(), -1, -1, $xrbAlignTop, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xrbAlignTop")
    XuiSendMessage ( g, #SetImage, 0, 0, 0, 0, 0, "." + $$PathSlash$ + "images" + $$PathSlash$ + "align_top.bmp")
    XuiSendMessage ( g, #SetHintString, 0,0,0,0,0, @"Align all with top-most")

    XuiRadioButton (@g, #Create, 200, 35, 32, 60, r0, grid)
     XuiSendMessage ( g, #SetCallback, grid, &Arrange(), -1, -1, $xrbAlignTopCenter, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xrbAlignTopCenter")
    XuiSendMessage ( g, #SetImage, 0, 0, 0, 0, 0, "." + $$PathSlash$ + "images" + $$PathSlash$ + "align_top_center.bmp")
    XuiSendMessage ( g, #SetHintString, 0,0,0,0,0, @"Center all with top-most")

     XuiRadioButton (@g, #Create, 232, 35, 32, 60, r0, grid)
     XuiSendMessage ( g, #SetCallback, grid, &Arrange(), -1, -1, $xrbAlignBottom, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xrbAlignBottom")
    XuiSendMessage ( g, #SetImage, 0, 0, 0, 0, 0, "." + $$PathSlash$ + "images" + $$PathSlash$ + "align_bottom.bmp")
    XuiSendMessage ( g, #SetHintString, 0,0,0,0,0, @"Align all with bottom-most")

     XuiRadioButton (@g, #Create, 264, 35, 32, 60, r0, grid)
     XuiSendMessage ( g, #SetCallback, grid, &Arrange(), -1, -1, $xrbAlignBottomCenter, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xrbAlignBottomCenter")
    XuiSendMessage ( g, #SetImage, 0, 0, 0, 0, 0, "." + $$PathSlash$ + "images" + $$PathSlash$ + "align_bottom_center.bmp")
    XuiSendMessage ( g, #SetHintString, 0,0,0,0,0, @"Center all with bottom-most")

     XuiRadioButton (@g, #Create, 232, 95, 32, 60, r0, grid)
     XuiSendMessage ( g, #SetCallback, grid, &Arrange(), -1, -1, $xrbSpaceBottom, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xrbSpaceBottom")
    XuiSendMessage ( g, #SetImage, 0, 0, 0, 0, 0, "." + $$PathSlash$ + "images" + $$PathSlash$ + "space_bottom.bmp")

    XuiRadioButton (@g, #Create, 200, 95, 32, 60, r0, grid)
     XuiSendMessage ( g, #SetCallback, grid, &Arrange(), -1, -1, $xrbSpaceTopCenter, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xrbSpaceTopCenter")
    XuiSendMessage ( g, #SetImage, 0, 0, 0, 0, 0, "." + $$PathSlash$ + "images" + $$PathSlash$ + "space_l_r_v.bmp")

    XuiRadioButton (@g, #Create, 168, 95, 32, 60, r0, grid)
     XuiSendMessage ( g, #SetCallback, grid, &Arrange(), -1, -1, $xrbSpaceTop, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xrbSpaceTop")
    XuiSendMessage ( g, #SetImage, 0, 0, 0, 0, 0, "." + $$PathSlash$ + "images" + $$PathSlash$ + "space_top.bmp")

     XuiRadioButton (@g, #Create, 264, 95, 32, 60, r0, grid)
     XuiSendMessage ( g, #SetCallback, grid, &Arrange(), -1, -1, $xrbSpaceSpaceToBottom, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xrbSpaceSpaceToBottom")
    XuiSendMessage ( g, #SetImage, 0, 0, 0, 0, 0, "." + $$PathSlash$ + "images" + $$PathSlash$ + "space_cent_v.bmp")

     GOSUB Resize
  END SUB

  SUB CreateWindow
     IF (v0 == 0) THEN v0 = designX
     IF (v1 == 0) THEN v1 = designY
     IF (v2 <= 0) THEN v2 = designWidth
     IF (v3 <= 0) THEN v3 = designHeight
     XuiWindow (@window, #WindowCreate, v0, v1, v2, v3, r0, @r1$)
     v0 = 0 : v1 = 0 : r0 = window : ATTACH r1$ TO display$
     GOSUB Create
     r1 = 0 : ATTACH display$ TO r1$
     XuiWindow (window, #WindowRegister, grid, -1, v2, v3, @r0, @"Arrange")
  END SUB

  SUB GetSmallestSize
  END SUB

  SUB Redrawn
     XuiCallback (grid, #Redrawn, v0, v1, v2, v3, r0, r1)
  END SUB

  SUB Resize
  END SUB

  SUB Selection
  END SUB

  SUB Initialize
     XuiGetDefaultMessageFuncArray (@func[])
     XgrMessageNameToNumber (@"LastMessage", @upperMessage)
  '
     func[#Callback]           = &XuiCallback ()               ' disable to handle Callback messages internally
  ' func[#GetSmallestSize]    = 0                             ' enable to add internal GetSmallestSize routine
  ' func[#Resize]             = 0                             ' enable to add internal Resize routine
  '
     DIM sub[upperMessage]
  '  sub[#Callback]            = SUBADDRESS (Callback)         ' enable to handle Callback messages internally
     sub[#Create]              = SUBADDRESS (Create)           ' must be subroutine in this function
     sub[#CreateWindow]        = SUBADDRESS (CreateWindow)     ' must be subroutine in this function
  '  sub[#GetSmallestSize]     = SUBADDRESS (GetSmallestSize)  ' enable to add internal GetSmallestSize routine
     sub[#Redrawn]             = SUBADDRESS (Redrawn)          ' generate #Redrawn callback if appropriate
  '  sub[#Resize]              = SUBADDRESS (Resize)           ' enable to add internal Resize routine
     sub[#Selection]           = SUBADDRESS (Selection)        ' routes Selection callbacks to subroutine
  '
     IF sub[0] THEN PRINT "Arrange() : Initialize : error ::: (undefined message)"
     IF func[0] THEN PRINT "Arrange() : Initialize : error ::: (undefined message)"
     XuiRegisterGridType (@Arrange, "Arrange", &Arrange(), @func[], @sub[])

     designX = 610
     designY = 51
     designWidth = 312
     designHeight = 248
  '
     gridType = Arrange
     XuiSetGridTypeProperty (gridType, @"x",                designX)
     XuiSetGridTypeProperty (gridType, @"y",                designY)
     XuiSetGridTypeProperty (gridType, @"width",            designWidth)
     XuiSetGridTypeProperty (gridType, @"height",           designHeight)
     XuiSetGridTypeProperty (gridType, @"maxWidth",         designWidth)
     XuiSetGridTypeProperty (gridType, @"maxHeight",        designHeight)
     XuiSetGridTypeProperty (gridType, @"minWidth",         designWidth)
     XuiSetGridTypeProperty (gridType, @"minHeight",        designHeight)
     XuiSetGridTypeProperty (gridType, @"can",              $$Focus OR $$Respond OR $$Callback)
     XuiSetGridTypeProperty (gridType, @"focusKid",         $xpbApply)
     IFZ message THEN RETURN
  END SUB
END FUNCTION

' ############################
' #####  ArrangeCode ()  #####
' ############################

FUNCTION  ArrangeCode (grid, message, v0, v1, v2, v3, kid, r1)
  SHARED SEL_LIST SelList[]
  STATIC mode
  POINT delta
   $Arrange                =   0  ' kid   0 grid type = Arrange
   $XuiLabel787            =   1  ' kid   1 grid type = XuiLabel
   $XuiLabel788            =   2  ' kid   2 grid type = XuiLabel
   $xpbApply               =   3  ' kid   3 grid type = XuiPushButton
   $xpbCancel              =   4  ' kid   4 grid type = XuiPushButton
   $xpbHelp                =   5  ' kid   5 grid type = XuiPushButton
   $XuiLabel792            =   6  ' kid   6 grid type = XuiLabel
   $xrbAlignLeft           =   7  ' kid   8 grid type = XuiRadioButton
   $xrbSpaceLeft           =   8  ' kid   9 grid type = XuiRadioButton
   $xrbAlignCenter         =   9  ' kid  10 grid type = XuiRadioButton
   $xrbSpaceCenter         =  10  ' kid  11 grid type = XuiRadioButton
   $xrbAlignRight          =  11  ' kid  12 grid type = XuiRadioButton
   $xrbSpaceRight          =  12  ' kid  13 grid type = XuiRadioButton
   $xrbAlignCenterBottom   =  13  ' kid  14 grid type = XuiRadioButton
   $xrbSpaceLeftRight      =  14  ' kid  15 grid type = XuiRadioButton
   $xrbAlignTop            =  15  ' kid  16 grid type = XuiRadioButton
   $xrbAlignTopCenter      =  16  ' kid  17 grid type = XuiRadioButton
   $xrbAlignBottom         =  17  ' kid  18 grid type = XuiRadioButton
   $xrbAlignBottomCenter   =  18  ' kid  19 grid type = XuiRadioButton
   $xrbSpaceBottom         =  19  ' kid  20 grid type = XuiRadioButton
  $xrbSpaceTopCenter      =  20  ' kid  22 grid type = XuiRadioButton
   $xrbSpaceTop            =  21  ' kid  21 grid type = XuiRadioButton
   $xrbSpaceSpaceToBottom  =  22  ' kid  23 grid type = XuiRadioButton
  $UpperKid               =  22  ' kid maximum
'
   IF (message == #Callback) THEN message = r1
'
   SELECT CASE message
      CASE #Selection      : GOSUB Selection
      CASE #CloseWindow : XuiSendMessage (grid, #HideWindow, 0, 0, 0, 0, 0, 0)
   END SELECT
   RETURN

  SUB Selection
     SELECT CASE kid
        CASE $xpbApply               : GOSUB Apply
        CASE $xpbCancel              : GOSUB Cancel
        CASE $xpbHelp                : Help()

        CASE $xrbAlignLeft           : mode = kid
        CASE $xrbSpaceLeft           : mode = kid
        CASE $xrbAlignCenter         : mode = kid
        CASE $xrbSpaceCenter         : mode = kid
        CASE $xrbAlignRight          : mode = kid
        CASE $xrbSpaceRight          : mode = kid
        CASE $xrbAlignCenterBottom   : mode = kid
        CASE $xrbSpaceLeftRight      : mode = kid

      CASE $xrbAlignTop            : mode = kid
        CASE $xrbAlignTopCenter      : mode = kid
        CASE $xrbAlignBottom         : mode = kid
        CASE $xrbAlignBottomCenter   : mode = kid
        CASE $xrbSpaceSpaceToBottom  : mode = kid
        CASE $xrbSpaceTop            : mode = kid
        CASE $xrbSpaceTopCenter      : mode = kid
        CASE $xrbSpaceBottom         : mode = kid
     END SELECT
  END SUB

  SUB SortX
    REDIM #Buff[UBOUND(SelList[])]
    DIM order[UBOUND(SelList[])]
    FOR i = 0 TO UBOUND(SelList[])
      XgrGetGridPositionAndSize(SelList[i].grid, @x,0,0,0)
      #Buff[i] = x
      order[i] = i
    NEXT i
    XstQuickSort(@#Buff[], @order[], 0, UBOUND(#Buff[]), $$SortIncreasing)
  END SUB

  SUB SortY
    REDIM #Buff[UBOUND(SelList[])]
    DIM order[UBOUND(SelList[])]
    FOR i = 0 TO UBOUND(SelList[])
      XgrGetGridPositionAndSize(SelList[i].grid, 0,@y,0,0)
      #Buff[i] = y
      order[i] = i
    NEXT i
    XstQuickSort(@#Buff[], @order[], 0, UBOUND(#Buff[]), $$SortIncreasing)
  END SUB

  SUB Apply
    SELECT CASE mode
      CASE $xrbAlignLeft : GOSUB AlignLeft
      CASE $xrbAlignRight : GOSUB AlignRight
      CASE $xrbAlignCenter: GOSUB AlignCenter
      CASE $xrbAlignCenterBottom : GOSUB AlignCenter

      CASE $xrbAlignTop: GOSUB AlignTop
      CASE $xrbAlignBottom: GOSUB AlignBottom
      CASE $xrbAlignTopCenter: GOSUB AlignVerticalCenter
      CASE $xrbAlignBottomCenter : GOSUB AlignVerticalCenter

      CASE $xrbSpaceCenter: GOSUB SpaceCenter
      CASE $xrbSpaceLeftRight: GOSUB SpaceLeftRight
      CASE $xrbSpaceLeft: GOSUB SpaceLeft
      CASE $xrbSpaceRight: GOSUB SpaceRight

      CASE $xrbSpaceSpaceToBottom  :GOSUB SpaceCenterV
        CASE $xrbSpaceTop            :GOSUB SpaceLeftV
        CASE $xrbSpaceTopCenter      :GOSUB SpaceLeftRightV
        CASE $xrbSpaceBottom         :GOSUB SpaceRightV
    END SELECT
  END SUB

  SUB Cancel
     XuiSendMessage(grid, #HideWindow,0,0,0,0,0,0)
  END SUB


  '##### HORIZONTAL #######

  SUB AlignLeft
    IF(UBOUND(SelList[]) < 1) THEN
      EXIT SUB
    END IF

    GOSUB SortX
    XgrGetGridPositionAndSize(SelList[order[0]].grid, @x, @y, @w, @h)
    leftmost = x
    delta.y = 0
    FOR z = 1 TO UBOUND(order[])
      i = order[z]
      XgrGetGridPositionAndSize(SelList[i].grid, @x, @y, @w, @h)
      delta.x = leftmost - x
      MoveObject(SelList[i].grid, SelList[i].index, SelList[i].type, delta)
    NEXT z

    XuiSendMessage(#CanvasGrid, #Redraw, 0,0,0,0,0,0)

  END SUB

  SUB AlignRight
    IF(UBOUND(SelList[]) < 1) THEN
      EXIT SUB
    END IF

    GOSUB SortX
    XgrGetGridPositionAndSize(SelList[order[UBOUND(order[])]].grid, @x, @y, @w, @h)
    rightmost = x + w
    delta.y = 0
    FOR z = 0 TO UBOUND(SelList[])
      i = order[z]
      XgrGetGridPositionAndSize(SelList[i].grid, @x, @y, @w, @h)
      delta.x = rightmost - (x + w)
      MoveObject(SelList[i].grid, SelList[i].index, SelList[i].type, delta)
    NEXT z

    XuiSendMessage(#CanvasGrid, #Redraw, 0,0,0,0,0,0)

  END SUB

  SUB AlignCenter
    IF(UBOUND(SelList[]) < 1) THEN
      EXIT SUB
    END IF

    GOSUB SortY
    IF(mode == $xrbAlignCenter) THEN
      XgrGetGridPositionAndSize(SelList[order[0]].grid, @x, @y, @w, @h)
    ELSE
      XgrGetGridPositionAndSize(SelList[order[UBOUND(order[])]].grid, @x, @y, @w, @h)
    END IF

    center = x + (w / 2)

    delta.y = 0
    FOR i = 0 TO UBOUND(SelList[])
       XgrGetGridPositionAndSize(SelList[i].grid, @x, @y, @w, @h)
      center2 = x + (w / 2)
      delta.x = center - center2
      MoveObject(SelList[i].grid, SelList[i].index, SelList[i].type, delta)
    NEXT i
    XuiSendMessage(#CanvasGrid, #Redraw, 0,0,0,0,0,0)

  END SUB

  '##### VERTICAL #############

  SUB AlignTop
    IF(UBOUND(SelList[]) < 1) THEN EXIT SUB

    GOSUB FindTopMost
    XgrGetGridPositionAndSize(SelList[index].grid, @x, @y, @w, @h)

    delta.x = 0
    FOR i = 0 TO UBOUND(SelList[])
      IF(i != index) THEN
         XgrGetGridPositionAndSize(SelList[i].grid, @x, @y, @w, @h)
        delta.y = top - y
        MoveObject(SelList[i].grid, SelList[i].index, SelList[i].type, delta)
      END IF
    NEXT i
    XuiSendMessage(#CanvasGrid, #Redraw, 0,0,0,0,0,0)
  END SUB

  SUB AlignBottom
     IF(UBOUND(SelList[]) < 1) THEN EXIT SUB
    GOSUB FindBottomMost
    XgrGetGridPositionAndSize(SelList[index].grid, @x, @y, @w, @h)

    delta.x = 0
    FOR i = 0 TO UBOUND(SelList[])
      IF(i != index) THEN
         XgrGetGridPositionAndSize(SelList[i].grid, @x, @y, @w, @h)
        delta.y = top - y
        MoveObject(SelList[i].grid, SelList[i].index, SelList[i].type, delta)
      END IF
    NEXT i
    XuiSendMessage(#CanvasGrid, #Redraw, 0,0,0,0,0,0)
  END SUB

  SUB AlignVerticalCenter
    IF(UBOUND(SelList[]) < 1) THEN
      EXIT SUB
    END IF

    IF(mode == $xrbAlignTopCenter) THEN
      GOSUB FindTopMost
    ELSE
      GOSUB FindBottomMost
    END IF

    XgrGetGridPositionAndSize(SelList[index].grid, @x, @y, @w, @h)
    center = y + (h / 2)

    delta.x = 0
    FOR i = 0 TO UBOUND(SelList[])
      IF(i != index) THEN
         XgrGetGridPositionAndSize(SelList[i].grid, @x, @y, @w, @h)
        center2 = y + (h / 2)
        delta.y = center - center2
        MoveObject(SelList[i].grid, SelList[i].index, SelList[i].type, delta)
      END IF
    NEXT i
    XuiSendMessage(#CanvasGrid, #Redraw, 0,0,0,0,0,0)

  END SUB

  SUB SpaceCenter
    IF(UBOUND(SelList[]) < 2) THEN
      EXIT SUB
    END IF

    GOSUB SortX
    XgrGetGridPositionAndSize(SelList[order[0]].grid, @x,@y,@w,@h)
    XgrGetGridPositionAndSize(SelList[order[1]].grid, @x1,@y1,@w1,@h1)
    space = (x1 + (w1 / 2)) - (x + (w / 2))

    delta.y = 0
    FOR i = 1 TO UBOUND(order[]) - 1
     XgrGetGridPositionAndSize(SelList[order[i]].grid, @x,@y,@w,@h)
      XgrGetGridPositionAndSize(SelList[order[i + 1]].grid, @x1,@y1,@w1,@h1)
      c1 = x + (w / 2)
      newx = c1 - (w1 / 2) + space
      delta.x = newx - x1
      MoveObject(SelList[order[i + 1]].grid, SelList[order[i + 1]].index, SelList[order[i + 1]].type, delta)
    NEXT i

    XuiSendMessage(#CanvasGrid, #Redraw, 0,0,0,0,0,0)

  END SUB

  SUB SpaceLeftRight
    IF(UBOUND(SelList[]) < 2) THEN
      EXIT SUB
    END IF

    GOSUB SortX
    XgrGetGridPositionAndSize(SelList[order[0]].grid, @x,@y,@w,@h)
    XgrGetGridPositionAndSize(SelList[order[1]].grid, @x1,@y1,@w1,@h1)
    space = x1 - (x + w)

    delta.y = 0
    FOR i = 1 TO UBOUND(order[]) - 1
     XgrGetGridPositionAndSize(SelList[order[i]].grid, @x,@y,@w,@h)
      XgrGetGridPositionAndSize(SelList[order[i + 1]].grid, @x1,@y1,@w1,@h1)
      delta.x = (x + w + space) - x1
      MoveObject(SelList[order[i + 1]].grid, SelList[order[i + 1]].index, SelList[order[i + 1]].type, delta)
    NEXT i

    XuiSendMessage(#CanvasGrid, #Redraw, 0,0,0,0,0,0)
  END SUB

  SUB SpaceLeft
    IF(UBOUND(SelList[]) < 2) THEN
      EXIT SUB
    END IF

    GOSUB SortX
    XgrGetGridPositionAndSize(SelList[order[0]].grid, @x,@y,@w,@h)
    XgrGetGridPositionAndSize(SelList[order[1]].grid, @x1,@y1,@w1,@h1)
    space = x1 - x

    delta.y = 0
    FOR i = 1 TO UBOUND(order[]) - 1
     XgrGetGridPositionAndSize(SelList[order[i]].grid, @x,@y,@w,@h)
      XgrGetGridPositionAndSize(SelList[order[i + 1]].grid, @x1,@y1,@w1,@h1)
      delta.x = (x + space) - x1
      MoveObject(SelList[order[i + 1]].grid, SelList[order[i + 1]].index, SelList[order[i + 1]].type, delta)
    NEXT i

    XuiSendMessage(#CanvasGrid, #Redraw, 0,0,0,0,0,0)
  END SUB

  SUB SpaceRight
    IF(UBOUND(SelList[]) < 2) THEN
      EXIT SUB
    END IF

    GOSUB SortX
    XgrGetGridPositionAndSize(SelList[order[0]].grid, @x,@y,@w,@h)
    XgrGetGridPositionAndSize(SelList[order[1]].grid, @x1,@y1,@w1,@h1)
    space = (x1 + w1) - (x + w)

    delta.y = 0
    FOR i = 1 TO UBOUND(order[]) - 1
     XgrGetGridPositionAndSize(SelList[order[i]].grid, @x,@y,@w,@h)
      XgrGetGridPositionAndSize(SelList[order[i + 1]].grid, @x1,@y1,@w1,@h1)
      delta.x = ((x + w) + space) - (x1 + w1)
      MoveObject(SelList[order[i + 1]].grid, SelList[order[i + 1]].index, SelList[order[i + 1]].type, delta)
    NEXT i

    XuiSendMessage(#CanvasGrid, #Redraw, 0,0,0,0,0,0)
  END SUB

  SUB SpaceCenterV
    IF(UBOUND(SelList[]) < 2) THEN
      EXIT SUB
    END IF

    GOSUB SortY
    XgrGetGridPositionAndSize(SelList[order[0]].grid, @x,@y,@w,@h)
    XgrGetGridPositionAndSize(SelList[order[1]].grid, @x1,@y1,@w1,@h1)
    space = (y1 + (h1 / 2)) - (y + (h / 2))

    delta.x = 0
    FOR i = 1 TO UBOUND(order[]) - 1
     XgrGetGridPositionAndSize(SelList[order[i]].grid, @x,@y,@w,@h)
      XgrGetGridPositionAndSize(SelList[order[i + 1]].grid, @x1,@y1,@w1,@h1)
      c1 = y + (h / 2)
      newy = c1 - (h1 / 2) + space
      delta.y = newy - y1
      MoveObject(SelList[order[i + 1]].grid, SelList[order[i + 1]].index, SelList[order[i + 1]].type, delta)
    NEXT i

    XuiSendMessage(#CanvasGrid, #Redraw, 0,0,0,0,0,0)

  END SUB

  SUB SpaceLeftRightV
    IF(UBOUND(SelList[]) < 2) THEN
      EXIT SUB
    END IF

    GOSUB SortY
    XgrGetGridPositionAndSize(SelList[order[0]].grid, @x,@y,@w,@h)
    XgrGetGridPositionAndSize(SelList[order[1]].grid, @x1,@y1,@w1,@h1)
    space = y1 - (y + h)

    delta.x = 0
    FOR i = 1 TO UBOUND(order[]) - 1
     XgrGetGridPositionAndSize(SelList[order[i]].grid, @x,@y,@w,@h)
      XgrGetGridPositionAndSize(SelList[order[i + 1]].grid, @x1,@y1,@w1,@h1)
      delta.y = (y + h + space) - y1
      MoveObject(SelList[order[i + 1]].grid, SelList[order[i + 1]].index, SelList[order[i + 1]].type, delta)
    NEXT i

    XuiSendMessage(#CanvasGrid, #Redraw, 0,0,0,0,0,0)
  END SUB

  SUB SpaceLeftV
    IF(UBOUND(SelList[]) < 2) THEN
      EXIT SUB
    END IF

    GOSUB SortY
    XgrGetGridPositionAndSize(SelList[order[0]].grid, @x,@y,@w,@h)
    XgrGetGridPositionAndSize(SelList[order[1]].grid, @x1,@y1,@w1,@h1)
    space = y1 - y

    delta.x = 0
    FOR i = 1 TO UBOUND(order[]) - 1
     XgrGetGridPositionAndSize(SelList[order[i]].grid, @x,@y,@w,@h)
      XgrGetGridPositionAndSize(SelList[order[i + 1]].grid, @x1,@y1,@w1,@h1)
      delta.y = (y + space) - y1
      MoveObject(SelList[order[i + 1]].grid, SelList[order[i + 1]].index, SelList[order[i + 1]].type, delta)
    NEXT i

    XuiSendMessage(#CanvasGrid, #Redraw, 0,0,0,0,0,0)
  END SUB

  SUB SpaceRightV
    IF(UBOUND(SelList[]) < 2) THEN
      EXIT SUB
    END IF

    GOSUB SortY
    XgrGetGridPositionAndSize(SelList[order[0]].grid, @x,@y,@w,@h)
    XgrGetGridPositionAndSize(SelList[order[1]].grid, @x1,@y1,@w1,@h1)
    space = (y1 + h1) - (y + h)

    delta.x = 0
    FOR i = 1 TO UBOUND(order[]) - 1
     XgrGetGridPositionAndSize(SelList[order[i]].grid, @x,@y,@w,@h)
      XgrGetGridPositionAndSize(SelList[order[i + 1]].grid, @x1,@y1,@w1,@h1)
      delta.y = ((y + h) + space) - (y1 + h1)
      MoveObject(SelList[order[i + 1]].grid, SelList[order[i + 1]].index, SelList[order[i + 1]].type, delta)
    NEXT i

    XuiSendMessage(#CanvasGrid, #Redraw, 0,0,0,0,0,0)
  END SUB

  '###### SUPPORT ##############

  SUB FindTopMost
    top = 9999999
    FOR i = 0 TO UBOUND(SelList[])
        XgrGetGridPositionAndSize(SelList[i].grid, @x, @y, @w, @h)
      IF(y < top) THEN
        index = i
        top = y
      END IF
    NEXT i
  END SUB

  SUB FindBottomMost
    top = -1
    FOR i = 0 TO UBOUND(SelList[])
        XgrGetGridPositionAndSize(SelList[i].grid, @x, @y, @w, @h)
      IF(y > top) THEN
        index = i
        top = y
      END IF
    NEXT i
  END SUB

  SUB FindLeftSpace
    'Calculate space between leftmosts right edge and left edge of next
    XgrGetGridPositionAndSize(SelList[order[0]].grid, @x, @y, @w, @h)
    XgrGetGridPositionAndSize(SelList[order[0]].grid, @x1, @y1, @w1, @h1)
    space = x1 - (x + w)
  END SUB

  SUB FindRightSpace
    'Calculate space between rightmosts left edge and right edge of previous
    XgrGetGridPositionAndSize(SelList[order[UBOUND(order[])]].grid, @x, @y, @w, @h)
    XgrGetGridPositionAndSize(SelList[order[UBOUND(order[]) - 1]].grid, @x1, @y1, @w1, @h1)
    space = x - (x1 + w1)
  END SUB

END FUNCTION

' ###########################
' #####  MoveObject ()  #####
' ###########################
'
FUNCTION  MoveObject (grid, index, type, POINT delta)
  SHARED FIELD FieldList[]
  SHARED FIELD LabelList[]

  #LayoutModified = $$TRUE

  XgrGetGridPositionAndSize(grid, @x, @y, @w, @h)
  SELECT CASE TRUE
    CASE (x + w + delta.x) >= #PageWidth  : RETURN
    CASE (x + delta.x) <= 0               : RETURN
    CASE (y + delta.y) <= 0               : RETURN
    CASE (y + h + delta.y) >= #PageHeight : RETURN
  END SELECT
  XgrSetGridPositionAndSize(grid, (x + delta.x), (y + delta.y), w, h)
  XuiGetKidArray(grid, #GetKidArray, @g, @parent, 0,0,0, @kids[])
  IF(kids[]) THEN
    FOR z = 1 TO UBOUND(kids[])
      XgrGetGridPositionAndSize(kids[z], @x, @y, @w, @h)
      XgrSetGridPositionAndSize(kids[z], (x + delta.x), (y + delta.y), w, h)
    NEXT z
  END IF

  XgrGetGridPositionAndSize(grid, @x, @y, @w, @h)
  SELECT CASE type
    CASE $$ENTRY, $$IMAGE:
       FieldList[index].x = x
       FieldList[index].y = y
    CASE $$LABEL, $$STATIC_IMAGE:
       LabelList[index].x = x
       LabelList[index].y = y
  END SELECT
END FUNCTION

' ######################
' #####  Blink ()  #####
' ######################
'
FUNCTION  Blink (timer, @count, msec, time)
  STATIC XLONG on
  STATIC XLONG grid
  $xlStatus = 14

  IFZ(grid) THEN
    XuiGetGridNumber(#Record, #GetGridNumber, @grid, 0,0,0, $xlStatus, 0)
  END IF

  INC count

  IF(on) THEN
    on = $$FALSE
    XuiSendMessage(grid, #SetImage, 0,0,0,0,0, #XFileDirectory$ + $$PathSlash$ + "images" + $$PathSlash$ + "dirty.bmp")
  ELSE
    on = $$TRUE
    XuiSendMessage(grid, #SetImage, 0,0,0,0,0, 0)
  END IF

  XuiSendMessage(grid, #RedrawGrid, 0,0,0,0, 0, 0)
END FUNCTION


'  ###########################
'  #####  ModifyPage ()  #####
'  ###########################
'
FUNCTION  ModifyPage (grid, message, v0, v1, v2, v3, r0, (r1, r1$, r1[], r1$[]))
   STATIC  designX,  designY,  designWidth,  designHeight
   STATIC  SUBADDR  sub[]
   STATIC  upperMessage
   STATIC  ModifyPage
'
   $ModifyPage      =   0  ' kid   0 grid type = ModifyPage
   $XuiLabel787     =   1  ' kid   1 grid type = XuiLabel
   $xtlPixelW       =   2  ' kid   2 grid type = XuiTextLine
   $XuiLabel789     =   3  ' kid   3 grid type = XuiLabel
   $xtlPixelH       =   4  ' kid   4 grid type = XuiTextLine
   $xpbPixelApply   =   5  ' kid   5 grid type = XuiPushButton
   $xpbInchesApply  =   6  ' kid   6 grid type = XuiPushButton
   $xtlInchesW      =   7  ' kid   7 grid type = XuiTextLine
   $xtlInchesH      =   8  ' kid   8 grid type = XuiTextLine
   $XuiLabel799     =   9  ' kid   9 grid type = XuiLabel
   $XuiLabel800     =  10  ' kid  10 grid type = XuiLabel
   $UpperKid        =  10  ' kid maximum
'
'
   IFZ sub[] THEN GOSUB Initialize
   IF XuiProcessMessage (grid, message, @v0, @v1, @v2, @v3, @r0, @r1, ModifyPage) THEN RETURN
   IF (message <= upperMessage) THEN GOSUB @sub[message]
   RETURN

  SUB Callback
     message = r1
     callback = message
     IF (message <= upperMessage) THEN GOSUB @sub[message]
  END SUB

  SUB Create
     IF (v0 <= 0) THEN v0 = 0
     IF (v1 <= 0) THEN v1 = 0
     IF (v2 <= 0) THEN v2 = designWidth
     IF (v3 <= 0) THEN v3 = designHeight
     XuiCreateGrid  (@grid, ModifyPage, @v0, @v1, @v2, @v3, r0, r1, &ModifyPage())
     XuiSendMessage ( grid, #SetGridName, 0, 0, 0, 0, 0, @"ModifyPage")
     XuiLabel       (@g, #Create, 4, 60, 68, 20, r0, grid)
     XuiSendMessage ( g, #SetCallback, grid, &ModifyPage(), -1, -1, $XuiLabel787, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"XuiLabel787")
     XuiSendMessage ( g, #SetAlign, $$AlignMiddleRight, $$JustifyCenter, -1, -1, 0, 0)
     XuiSendMessage ( g, #SetBorder, $$BorderNone, $$BorderNone, $$BorderNone, 0, 0, 0)
     XuiSendMessage ( g, #SetTexture, $$TextureNone, 0, 0, 0, 0, 0)
     XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"inches:")
     XuiTextLine    (@g, #Create, 88, 16, 48, 24, r0, grid)
     XuiSendMessage ( g, #SetCallback, grid, &ModifyPage(), -1, -1, $xtlPixelW, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xtlPixelW")
     XuiSendMessage ( g, #SetColor, $$White, $$Black, $$Black, $$White, 0, 0)
     XuiSendMessage ( g, #SetBorder, $$BorderLower1, $$BorderLower1, $$BorderNone, 0, 0, 0)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 1, @"XuiArea790")
     XuiSendMessage ( g, #SetColor, $$White, $$Black, $$Black, $$White, 1, 0)
     XuiLabel       (@g, #Create, 4, 16, 68, 20, r0, grid)
     XuiSendMessage ( g, #SetCallback, grid, &ModifyPage(), -1, -1, $XuiLabel789, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"XuiLabel789")
     XuiSendMessage ( g, #SetAlign, $$AlignMiddleRight, $$JustifyCenter, -1, -1, 0, 0)
     XuiSendMessage ( g, #SetBorder, $$BorderNone, $$BorderNone, $$BorderNone, 0, 0, 0)
     XuiSendMessage ( g, #SetTexture, $$TextureNone, 0, 0, 0, 0, 0)
     XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"pixels:")
     XuiTextLine    (@g, #Create, 164, 16, 48, 24, r0, grid)
     XuiSendMessage ( g, #SetCallback, grid, &ModifyPage(), -1, -1, $xtlPixelH, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xtlPixelH")
     XuiSendMessage ( g, #SetColor, $$White, $$Black, $$Black, $$White, 0, 0)
     XuiSendMessage ( g, #SetBorder, $$BorderLower1, $$BorderLower1, $$BorderNone, 0, 0, 0)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 1, @"XuiArea792")
     XuiSendMessage ( g, #SetColor, $$White, $$Black, $$Black, $$White, 1, 0)
     XuiPushButton  (@g, #Create, 224, 16, 52, 24, r0, grid)
     XuiSendMessage ( g, #SetCallback, grid, &ModifyPage(), -1, -1, $xpbPixelApply, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xpbPixelApply")
     XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"Apply")
     XuiPushButton  (@g, #Create, 224, 56, 52, 24, r0, grid)
     XuiSendMessage ( g, #SetCallback, grid, &ModifyPage(), -1, -1, $xpbInchesApply, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xpbInchesApply")
     XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"Apply")
     XuiTextLine    (@g, #Create, 88, 56, 48, 24, r0, grid)
     XuiSendMessage ( g, #SetCallback, grid, &ModifyPage(), -1, -1, $xtlInchesW, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xtlInchesW")
     XuiSendMessage ( g, #SetColor, $$White, $$Black, $$Black, $$White, 0, 0)
     XuiSendMessage ( g, #SetBorder, $$BorderLower1, $$BorderLower1, $$BorderNone, 0, 0, 0)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 1, @"XuiArea796")
     XuiSendMessage ( g, #SetColor, $$White, $$Black, $$Black, $$White, 1, 0)
     XuiTextLine    (@g, #Create, 164, 56, 48, 24, r0, grid)
     XuiSendMessage ( g, #SetCallback, grid, &ModifyPage(), -1, -1, $xtlInchesH, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xtlInchesH")
     XuiSendMessage ( g, #SetColor, $$White, $$Black, $$Black, $$White, 0, 0)
     XuiSendMessage ( g, #SetBorder, $$BorderLower1, $$BorderLower1, $$BorderNone, 0, 0, 0)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 1, @"XuiArea798")
     XuiSendMessage ( g, #SetColor, $$White, $$Black, $$Black, $$White, 1, 0)
     XuiLabel       (@g, #Create, 140, 20, 20, 20, r0, grid)
     XuiSendMessage ( g, #SetCallback, grid, &ModifyPage(), -1, -1, $XuiLabel799, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"XuiLabel799")
     XuiSendMessage ( g, #SetBorder, $$BorderNone, $$BorderNone, $$BorderNone, 0, 0, 0)
     XuiSendMessage ( g, #SetTexture, $$TextureNone, 0, 0, 0, 0, 0)
     XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"x")
     XuiLabel       (@g, #Create, 140, 60, 20, 20, r0, grid)
     XuiSendMessage ( g, #SetCallback, grid, &ModifyPage(), -1, -1, $XuiLabel800, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"XuiLabel800")
     XuiSendMessage ( g, #SetBorder, $$BorderNone, $$BorderNone, $$BorderNone, 0, 0, 0)
     XuiSendMessage ( g, #SetTexture, $$TextureNone, 0, 0, 0, 0, 0)
     XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"x")
     GOSUB Resize
  END SUB

  SUB CreateWindow
     IF (v0 == 0) THEN v0 = designX
     IF (v1 == 0) THEN v1 = designY
     IF (v2 <= 0) THEN v2 = designWidth
     IF (v3 <= 0) THEN v3 = designHeight
     XuiWindow (@window, #WindowCreate, v0, v1, v2, v3, r0, @r1$)
     v0 = 0 : v1 = 0 : r0 = window : ATTACH r1$ TO display$
     GOSUB Create
     r1 = 0 : ATTACH display$ TO r1$
     XuiWindow (window, #WindowRegister, grid, -1, v2, v3, @r0, @"ModifyPage")
  END SUB

  SUB GetSmallestSize
  END SUB

  SUB Redrawn
     XuiCallback (grid, #Redrawn, v0, v1, v2, v3, r0, r1)
  END SUB

  SUB Resize
  END SUB

  SUB Selection
  END SUB

  SUB Initialize
     XuiGetDefaultMessageFuncArray (@func[])
     XgrMessageNameToNumber (@"LastMessage", @upperMessage)
  '
     func[#Callback]           = &XuiCallback ()               ' disable to handle Callback messages internally
  ' func[#GetSmallestSize]    = 0                             ' enable to add internal GetSmallestSize routine
  ' func[#Resize]             = 0                             ' enable to add internal Resize routine
  '
     DIM sub[upperMessage]
  '  sub[#Callback]            = SUBADDRESS (Callback)         ' enable to handle Callback messages internally
     sub[#Create]              = SUBADDRESS (Create)           ' must be subroutine in this function
     sub[#CreateWindow]        = SUBADDRESS (CreateWindow)     ' must be subroutine in this function
  '  sub[#GetSmallestSize]     = SUBADDRESS (GetSmallestSize)  ' enable to add internal GetSmallestSize routine
     sub[#Redrawn]             = SUBADDRESS (Redrawn)          ' generate #Redrawn callback if appropriate
  '  sub[#Resize]              = SUBADDRESS (Resize)           ' enable to add internal Resize routine
     sub[#Selection]           = SUBADDRESS (Selection)        ' routes Selection callbacks to subroutine
  '
     IF sub[0] THEN PRINT "ModifyPage() : Initialize : error ::: (undefined message)"
     IF func[0] THEN PRINT "ModifyPage() : Initialize : error ::: (undefined message)"
     XuiRegisterGridType (@ModifyPage, "ModifyPage", &ModifyPage(), @func[], @sub[])
  '
  ' Don't remove the following 4 lines, or WindowFromFunction/WindowToFunction will not work
  '
     designX = 550
     designY = 92
     designWidth = 288
     designHeight = 96
  '
     gridType = ModifyPage
     XuiSetGridTypeProperty (gridType, @"x",                designX)
     XuiSetGridTypeProperty (gridType, @"y",                designY)
     XuiSetGridTypeProperty (gridType, @"width",            designWidth)
     XuiSetGridTypeProperty (gridType, @"height",           designHeight)
     XuiSetGridTypeProperty (gridType, @"maxWidth",         designWidth)
     XuiSetGridTypeProperty (gridType, @"maxHeight",        designHeight)
     XuiSetGridTypeProperty (gridType, @"minWidth",         designWidth)
     XuiSetGridTypeProperty (gridType, @"minHeight",        designHeight)
     XuiSetGridTypeProperty (gridType, @"can",              $$Focus OR $$Respond OR $$Callback OR $$TextSelection)
     XuiSetGridTypeProperty (gridType, @"focusKid",         $xtlPixelW)
     XuiSetGridTypeProperty (gridType, @"inputTextString",  $xtlPixelW)
     IFZ message THEN RETURN
  END SUB
END FUNCTION
'
'
' ###############################
' #####  ModifyPageCode ()  #####
' ###############################
'
FUNCTION  ModifyPageCode (grid, message, v0, v1, v2, v3, kid, r1)
'
   $ModifyPage      =   0  ' kid   0 grid type = ModifyPage
   $XuiLabel787     =   1  ' kid   1 grid type = XuiLabel
   $xtlPixelW       =   2  ' kid   2 grid type = XuiTextLine
   $XuiLabel789     =   3  ' kid   3 grid type = XuiLabel
   $xtlPixelH       =   4  ' kid   4 grid type = XuiTextLine
   $xpbPixelApply   =   5  ' kid   5 grid type = XuiPushButton
   $xpbInchesApply  =   6  ' kid   6 grid type = XuiPushButton
   $xtlInchesW      =   7  ' kid   7 grid type = XuiTextLine
   $xtlInchesH      =   8  ' kid   8 grid type = XuiTextLine
   $XuiLabel799     =   9  ' kid   9 grid type = XuiLabel
   $XuiLabel800     =  10  ' kid  10 grid type = XuiLabel
   $UpperKid        =  10  ' kid maximum

'
   IF (message == #Callback) THEN message = r1
'
   SELECT CASE message
    CASE #Notify      : GOSUB Update
      CASE #Selection      : GOSUB Selection
      CASE #CloseWindow : XuiSendMessage (grid, #HideWindow, 0, 0, 0, 0, 0, 0)
   END SELECT
   RETURN

  SUB Selection
     SELECT CASE kid
        CASE $xpbPixelApply   : GOSUB ChangePagePx
        CASE $xpbInchesApply  : GOSUB ChangePageIn
     END SELECT
  END SUB

  SUB ChangePagePx
    XuiSendMessage(grid, #GetTextString,0,0,0,0,$xtlPixelW, @w$)
    XuiSendMessage(grid, #GetTextString,0,0,0,0,$xtlPixelH, @h$)
    cw = XLONG(w$)
    ch = XLONG(h$)
    #PageWidth = cw
    #PageHeight = ch
    GOSUB FinishChange
  END SUB

  SUB ChangePageIn
    XuiSendMessage(grid, #GetTextString,0,0,0,0,$xtlInchesW, @w$)
    XuiSendMessage(grid, #GetTextString,0,0,0,0,$xtlInchesH, @h$)
    cw = XLONG(SINGLE(w$) * #DPI_X)
    ch = XLONG(SINGLE(h$) * #DPI_Y)
    #PageWidth = cw
    #PageHeight = ch
    GOSUB FinishChange
  END SUB

  SUB FinishChange
    XgrGetGridPositionAndSize(#CanvasGrid, @gx, @gy, @gw, @gh)
    XgrGetWindowPositionAndSize(#GeoFileWin, @x, @y, @w, @h)
    deltax = (x + gx + #PageWidth + (w - gw) + #windowBorderWidth) - #displayWidth
    deltay = (y + gy + #PageHeight + (h - gh) + #windowTitleHeight) - #displayHeight

      'Try to move window to accomodate size
    IF(deltax > 0) THEN
      IF(x > deltax) THEN
        x = x - deltax
      ELSE
        x = #windowBorderWidth
        #PageWidth = #displayWidth - ((2 * #windowBorderWidth) + gx + (w - (gx + gw)))
      END IF
    END IF

    IF(deltay > 0) THEN
      IF(y > deltay) THEN
        y = y - deltay
      ELSE
        y = #windowTitleHeight
        #PageHeight = #displayHeight - (#windowTitleHeight + #windowBorderWidth + gy + (h - (gy + gh)))
      END IF
    END IF

    XgrSetWindowPositionAndSize(#GeoFileWin, x, y, w, h)
    ResizePage(#PageWidth, #PageHeight)
    GOSUB Update
  END SUB

  SUB Update
    XuiSendMessage(grid, #SetTextString, 0,0,0,0, $xtlInchesW, LCLIP$(FORMAT$(".##", (SINGLE(#PageWidth) / SINGLE(#DPI_X))), 1))
    XuiSendMessage(grid, #RedrawText, 0,0,0,0, $xtlInchesW,0)
    XuiSendMessage(grid, #SetTextString, 0,0,0,0, $xtlInchesH, LCLIP$(FORMAT$(".##", (SINGLE(#PageHeight) / SINGLE(#DPI_Y))), 1))
    XuiSendMessage(grid, #RedrawText, 0,0,0,0, $xtlInchesH,0)
    XuiSendMessage(grid, #SetTextString, 0,0,0,0, $xtlPixelW, STRING$(#PageWidth))
    XuiSendMessage(grid, #RedrawText, 0,0,0,0, $xtlPixelW,0)
    XuiSendMessage(grid, #SetTextString, 0,0,0,0, $xtlPixelH, STRING$(#PageHeight))
    XuiSendMessage(grid, #RedrawText, 0,0,0,0, $xtlPixelH,0)
  END SUB

END FUNCTION

FUNCTION  UpdateSummaryField (index)
  SHARED FIELD FieldList[]
  SHARED RECORD RecordList[]
  SHARED StringData$[]

  IFZ(RecordList[]) THEN RETURN

  'Orphaned summary field
  IF(FieldList[index].max = -1) THEN
    result$ = "N/A"
    GOSUB UpdateAllRecords
    RETURN
  END IF

  SELECT CASE FieldList[index].min
    CASE $$SUM_TYPE_TOTAL   : GOSUB Total
    CASE $$SUM_TYPE_AVERAGE : GOSUB Average
    CASE $$SUM_TYPE_MIN     : GOSUB Min
    CASE $$SUM_TYPE_MAX     : GOSUB Max
  END SELECT

  SUB Total
    field = FieldList[index].max
    FOR i = 0 TO UBOUND(RecordList[])
      IF(#ShowOnlyMarked && RecordList[i].marked == $$FALSE) THEN
        DO NEXT
      END IF
      SELECT CASE FieldList[field].type
        CASE $$FT_INTEGER:
          result$$ = result$$ + GIANT(StringData$[RecordList[i].first + field])
        CASE $$FT_REAL:
          result# = result# + DOUBLE(StringData$[RecordList[i].first + field])
       END SELECT
    NEXT i

      GOSUB ReturnResult
      GOSUB UpdateAllRecords
   END SUB

  SUB Average
    field = FieldList[index].max
    count = 0
    FOR i = 0 TO UBOUND(RecordList[])
      IF(#ShowOnlyMarked && RecordList[i].marked == $$FALSE) THEN
        DO NEXT
      END IF
      result# = result# + DOUBLE(StringData$[RecordList[i].first + field])
      INC count
    NEXT i

    result# = result# / count
    result$ = LCLIP$(FORMAT$(".##", result#),1)
    GOSUB UpdateAllRecords
  END SUB

  SUB Max
    field = FieldList[index].max
    FOR i = 0 TO UBOUND(RecordList[])
      IF(#ShowOnlyMarked && RecordList[i].marked == $$FALSE) THEN
        DO NEXT
      END IF
      SELECT CASE FieldList[field].type
        CASE $$FT_INTEGER:
          temp$$ = GIANT(StringData$[RecordList[i].first + field])
          IF(temp$$ > result$$) THEN result$$ = temp$$
        CASE $$FT_REAL:
          temp# = DOUBLE(StringData$[RecordList[i].first + field])
          IF(temp# > result#) THEN result# = temp#
       END SELECT
    NEXT i
    GOSUB ReturnResult
    GOSUB UpdateAllRecords
  END SUB

  SUB Min
    field = FieldList[index].max
    IF(#ShowOnlyMarked) THEN
      IFZ(GetFirstRecord(@record, $$GET_MARKED)) THEN
        result$$ = 0
        GOSUB ReturnResult
      END IF
    ELSE
      record = 0
    END IF
    SELECT CASE FieldList[field].type
      CASE $$FT_INTEGER:
          result$$ = GIANT(StringData$[RecordList[record].first + field])
      CASE $$FT_REAL:
          result# = DOUBLE(StringData$[RecordList[record].first + field])
    END SELECT
    FOR i = 0 TO UBOUND(RecordList[])
      IF(#ShowOnlyMarked && RecordList[i].marked == $$FALSE) THEN
        DO NEXT
      END IF
      SELECT CASE FieldList[field].type
        CASE $$FT_INTEGER:
          temp$$ = GIANT(StringData$[RecordList[i].first + field])
          IF(temp$$ < result$$) THEN result$$ = temp$$
        CASE $$FT_REAL:
          temp# = DOUBLE(StringData$[RecordList[i].first + field])
          IF(temp# < result#) THEN result# = temp#
       END SELECT
    NEXT i
    GOSUB ReturnResult
    GOSUB UpdateAllRecords
  END SUB

  SUB ReturnResult
    SELECT CASE FieldList[field].type
      CASE $$FT_INTEGER:
        result$ = STRING$(result$$)
      CASE $$FT_REAL:
        result$ = LCLIP$(FORMAT$(".##", result#),1)
    END SELECT
  END SUB

  SUB UpdateAllRecords
    FOR record = 0 TO UBOUND(RecordList[])
   		first = RecordList[record].first
      StringData$[first + index] = result$
    NEXT record
  END SUB
END FUNCTION


' #############################
' #####  CenterWindow ()  #####
' #############################
'
FUNCTION  CenterWindow (grid)
  XgrGetGridWindow(grid, @gwin)
  XgrGetWindowPositionAndSize(gwin, @gx, @gy, @gw, @gh)
  gx = (#displayWidth / 2) - (gw / 2)
  gy = (#displayHeight / 2) - (gh / 2)
  XgrSetWindowPositionAndSize(gwin, gx, gy, gw, gh)
END FUNCTION

' ##############################
' #####  UpdateLayouts ()  #####
' ##############################
'
' When fields are added or deleted,
' all existing layouts need to be updated
'
' Loop through all layouts, except current layout
'
' new = $$TRUE - new field added
' new = $$FALSE - field deleted
'
' Yes, this is an offensive kludge, but I implented this towards the
' end, and my design didn't accomodate switching layouts very well.
'
FUNCTION  UpdateLayouts (new, index)
  SHARED FIELD FieldList[]
  SHARED FIELD LabelList[]
  FIELD tempfields[]
  FIELD templabels[]
  FIELD temp

  REDIM #Buff$[]
  GetLayouts(@#Buff$[])
  FOR z = 0 TO UBOUND(#Buff$[])
    IF(#Buff$[z] != #CurrentLayout$) THEN
      Log($$LOG_INFO, "Updating layout " + #Buff$[z])
      GOSUB ReadFields
    END IF
  NEXT z

  SUB ReadFields
     file$ = #CurrentProject$ + $$PathSlash$ + #Buff$[z]
     fd = OPEN(file$, $$RD)

     IF(fd <= 0) THEN
      Log($$LOG_INFO, "UpdateLayouts(): Could not open layout " + layout$)
      ShowMessage("Could not load: " + layout$)
      RETURN $$FALSE
     END IF

     fields = 0
     READ [fd],fields

     FOR i = 0 TO fields - 1
      READ [fd],temp
      REDIM tempfields[i]
      tempfields[i] = temp
      Log($$LOG_DEBUG, "Reading " + tempfields[i].name)
     NEXT i
     IF(new) THEN
       REDIM tempfields[i]
       tempfields[i] = FieldList[index]
       tempfields[i].in_layout = $$FALSE
       tempfields[i].visible = $$FALSE
       Log($$LOG_DEBUG, "Adding " + tempfields[i].name)
     END IF

     READ [fd],fields

     FOR i = 0 TO fields - 1
       READ [fd],temp
       REDIM templabels[i]
       templabels[i] = temp
     NEXT i

     'Read background color of canvas grid
     READ [fd], back, text, low, high
     'Read border of canvas grid
     READ [fd], b1, b2, b3, b4
      'Read layouts background image
     READ [fd],fields
     IF(fields > 0) THEN
         READ[fd], image$
     END IF
     READ [fd], pagewidth
     READ [fd], pageheight
     CLOSE(fd)
     GOSUB SaveLayout
  END SUB

  SUB SaveLayout
   fd = OPEN(file$, $$WRNEW)
   IF(fd <= 0) THEN
      Log($$LOG_DEBUG, "Count not open layout file: " + layout$)
      ShowMessage("Could not save layout!")
      RETURN $$FALSE
   END IF
   IF(new == $$FALSE) THEN
     fields = UBOUND(tempfields[])
   ELSE
     fields = UBOUND(tempfields[]) + 1
   END IF
   WRITE [fd], fields
   FOR i = 0 TO UBOUND(tempfields[])
      IF(new == $$FALSE)
        IF(tempfields[i].name != FieldList[index].name) THEN
          temp = tempfields[i]
          WRITE [fd],temp
        ELSE
           Log($$LOG_DEBUG, "Skipping " + FieldList[index].name)
        END IF
      ELSE
        temp = tempfields[i]
        WRITE [fd],temp
      END IF
   NEXT i


   labels = UBOUND(templabels[]) + 1

   WRITE [fd], labels
   FOR i = 0 TO UBOUND(templabels[])
      temp = templabels[i]
      WRITE [fd],temp
   NEXT i

   'save colors of grid
   WRITE [fd], back, text, low, high
   WRITE [fd], b1, b2, b3, b4
   fields = LEN(image$)
   WRITE [fd], fields
   WRITE [fd],image$
   WRITE [fd], pagewidth
   WRITE [fd], pageheight
   CLOSE(fd)
   Log($$LOG_INFO, "Updated Layout " + #Buff$[z])
 END SUB

END FUNCTION

' ###############################
' #####  GetLabelByName ()  #####
' ###############################
'
FUNCTION  GetLabelByName (name$, @index)
  SHARED FIELD LabelList[]

  FOR i = 0 TO UBOUND(LabelList[])
    IF(LabelList[i].name == name$) THEN
      index = i
      RETURN $$TRUE
    END IF
  NEXT i

  RETURN $$FALSE

END FUNCTION


'  #####################
'  #####  Bump ()  #####
'  #####################
'
FUNCTION  Bump (grid, message, v0, v1, v2, v3, r0, (r1, r1$, r1[], r1$[]))
   STATIC  designX,  designY,  designWidth,  designHeight
   STATIC  SUBADDR  sub[]
   STATIC  upperMessage
   STATIC  Bump

   $Bump      =   0  ' kid   0 grid type = Bump
   $xpbLeft   =   1  ' kid   1 grid type = XuiPushButton
   $xbpDown   =   2  ' kid   2 grid type = XuiPushButton
   $xpbUp     =   3  ' kid   3 grid type = XuiPushButton
   $xpbRight  =   4  ' kid   4 grid type = XuiPushButton
   $UpperKid  =   4  ' kid maximum

   IFZ sub[] THEN GOSUB Initialize
   IF XuiProcessMessage (grid, message, @v0, @v1, @v2, @v3, @r0, @r1, Bump) THEN RETURN
   IF (message <= upperMessage) THEN GOSUB @sub[message]
   RETURN

  SUB Callback
     message = r1
     callback = message
     IF (message <= upperMessage) THEN GOSUB @sub[message]
  END SUB

  SUB Create
     IF (v0 <= 0) THEN v0 = 0
     IF (v1 <= 0) THEN v1 = 0
     IF (v2 <= 0) THEN v2 = designWidth
     IF (v3 <= 0) THEN v3 = designHeight
     XuiCreateGrid  (@grid, Bump, @v0, @v1, @v2, @v3, r0, r1, &Bump())
     XuiSendMessage ( grid, #SetGridName, 0, 0, 0, 0, 0, @"Bump")

     XuiPushButton  (@g, #Create, 0, 32, 64, 52, r0, grid)
     XuiSendMessage ( g, #SetCallback, grid, &Bump(), -1, -1, $xpbLeft, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xpbLeft")
     XuiSendMessage ( g, #SetStyle, 2, 3, 0, 0, 0, 0)
     XuiSendMessage ( g, #SetBorder, $$BorderFlat1, $$BorderFlat1, $$BorderLower1, 0, 0, 0)
     XuiSendMessage ( g, #SetImage, 0, 0, 0, 0, 0, "." + $$PathSlash$ + "images" + $$PathSlash$ + "bump_left.bmp")

     XuiPushButton  (@g, #Create, 0, 84, 132, 32, r0, grid)
     XuiSendMessage ( g, #SetCallback, grid, &Bump(), -1, -1, $xbpDown, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xbpDown")
     XuiSendMessage ( g, #SetStyle, 2, 3, 0, 0, 0, 0)
     XuiSendMessage ( g, #SetBorder, $$BorderFlat1, $$BorderFlat1, $$BorderLower1, 0, 0, 0)
     XuiSendMessage ( g, #SetImage, 0, 0, 0, 0, 0, "." + $$PathSlash$ + "images" + $$PathSlash$ + "bump_down.bmp")

     XuiPushButton  (@g, #Create, 0, 0, 132, 32, r0, grid)
     XuiSendMessage ( g, #SetCallback, grid, &Bump(), -1, -1, $xpbUp, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xpbUp")
     XuiSendMessage ( g, #SetStyle, 2, 3, 0, 0, 0, 0)
     XuiSendMessage ( g, #SetBorder, $$BorderFlat1, $$BorderFlat1, $$BorderLower1, 0, 0, 0)
     XuiSendMessage ( g, #SetImage, 0, 0, 0, 0, 0, "." + $$PathSlash$ + "images" + $$PathSlash$ + "bump_up.bmp")

     XuiPushButton  (@g, #Create, 64, 32, 68, 52, r0, grid)
     XuiSendMessage ( g, #SetCallback, grid, &Bump(), -1, -1, $xpbRight, grid)
     XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xpbRight")
     XuiSendMessage ( g, #SetStyle, 2, 3, 0, 0, 0, 0)
     XuiSendMessage ( g, #SetBorder, $$BorderFlat1, $$BorderFlat1, $$BorderLower1, 0, 0, 0)
     XuiSendMessage ( g, #SetImage, 0, 0, 0, 0, 0, "." + $$PathSlash$ + "images" + $$PathSlash$ + "bump_right.bmp")
     GOSUB Resize
  END SUB

  SUB CreateWindow
     IF (v0 == 0) THEN v0 = designX
     IF (v1 == 0) THEN v1 = designY
     IF (v2 <= 0) THEN v2 = designWidth
     IF (v3 <= 0) THEN v3 = designHeight
     XuiWindow (@window, #WindowCreate, v0, v1, v2, v3, r0, @r1$)
     v0 = 0 : v1 = 0 : r0 = window : ATTACH r1$ TO display$
     GOSUB Create
     r1 = 0 : ATTACH display$ TO r1$
     XuiWindow (window, #WindowRegister, grid, -1, v2, v3, @r0, @"Bump")
  END SUB

  SUB GetSmallestSize
  END SUB

  SUB Redrawn
     XuiCallback (grid, #Redrawn, v0, v1, v2, v3, r0, r1)
  END SUB

  SUB Resize
  END SUB

  SUB Selection
  END SUB

  SUB Initialize
     XuiGetDefaultMessageFuncArray (@func[])
     XgrMessageNameToNumber (@"LastMessage", @upperMessage)
  '
     func[#Callback]           = &XuiCallback ()               ' disable to handle Callback messages internally
  ' func[#GetSmallestSize]    = 0                             ' enable to add internal GetSmallestSize routine
  ' func[#Resize]             = 0                             ' enable to add internal Resize routine
  '
     DIM sub[upperMessage]
  '  sub[#Callback]            = SUBADDRESS (Callback)         ' enable to handle Callback messages internally
     sub[#Create]              = SUBADDRESS (Create)           ' must be subroutine in this function
     sub[#CreateWindow]        = SUBADDRESS (CreateWindow)     ' must be subroutine in this function
  '  sub[#GetSmallestSize]     = SUBADDRESS (GetSmallestSize)  ' enable to add internal GetSmallestSize routine
     sub[#Redrawn]             = SUBADDRESS (Redrawn)          ' generate #Redrawn callback if appropriate
  '  sub[#Resize]              = SUBADDRESS (Resize)           ' enable to add internal Resize routine
     sub[#Selection]           = SUBADDRESS (Selection)        ' routes Selection callbacks to subroutine
  '
     IF sub[0] THEN PRINT "Bump() : Initialize : error ::: (undefined message)"
     IF func[0] THEN PRINT "Bump() : Initialize : error ::: (undefined message)"
     XuiRegisterGridType (@Bump, "Bump", &Bump(), @func[], @sub[])
  '
  ' Don't remove the following 4 lines, or WindowFromFunction/WindowToFunction will not work
  '
     designX = 1065
     designY = 40
     designWidth = 132
     designHeight = 116
  '
     gridType = Bump
     XuiSetGridTypeProperty (gridType, @"x",                designX)
     XuiSetGridTypeProperty (gridType, @"y",                designY)
     XuiSetGridTypeProperty (gridType, @"width",            designWidth)
     XuiSetGridTypeProperty (gridType, @"height",           designHeight)
     XuiSetGridTypeProperty (gridType, @"maxWidth",         designWidth)
     XuiSetGridTypeProperty (gridType, @"maxHeight",        designHeight)
     XuiSetGridTypeProperty (gridType, @"minWidth",         designWidth)
     XuiSetGridTypeProperty (gridType, @"minHeight",        designHeight)
     XuiSetGridTypeProperty (gridType, @"can",              $$Focus OR $$Respond OR $$Callback)
     XuiSetGridTypeProperty (gridType, @"focusKid",         $xpbLeft)
     IFZ message THEN RETURN
  END SUB
END FUNCTION

' #########################
' #####  BumpCode ()  #####
' #########################
'
FUNCTION  BumpCode (grid, message, v0, v1, v2, v3, kid, r1)
  SHARED SEL_LIST SelList[]
  POINT delta

  $Bump      =   0  ' kid   0 grid type = Bump
  $xpbLeft   =   1  ' kid   1 grid type = XuiPushButton
  $xbpDown   =   2  ' kid   2 grid type = XuiPushButton
  $xpbUp     =   3  ' kid   3 grid type = XuiPushButton
  $xpbRight  =   4  ' kid   4 grid type = XuiPushButton
  $UpperKid  =   4  ' kid maximum

  IF (message == #Callback) THEN message = r1

  SELECT CASE message
    CASE #Selection      : GOSUB Selection
    CASE #CloseWindow : XuiSendMessage (grid, #HideWindow, 0, 0, 0, 0, 0, 0)
  END SELECT
  RETURN

  SUB Selection
    IFZ(SelList[]) THEN RETURN
     SELECT CASE kid
        CASE $xpbLeft   : GOSUB Left
        CASE $xbpDown   : GOSUB Down
        CASE $xpbUp     : GOSUB Up
        CASE $xpbRight  : GOSUB Right
     END SELECT
    FOR i = 0 TO UBOUND(SelList[])
      MoveObject(SelList[i].grid, SelList[i].index, SelList[i].type, delta)
    NEXT i
    XuiSendMessage(#CanvasGrid, #Redraw, 0,0,0,0,0,0)
  END SUB

  SUB Left
    delta.y = 0
    delta.x = -1
  END SUB

  SUB Down
    delta.y = 1
    delta.x = 0
  END SUB

  SUB Up
    delta.y = -1
    delta.x = 0
  END SUB

  SUB Right
    delta.y = 0
    delta.x = 1
  END SUB

END FUNCTION

' ###########################
' #####  ResizePage ()  #####
' ###########################
'
FUNCTION  ResizePage (cw, ch)

  $xrbDesign         =   8
  $xrbDataEntry      =   9
  $xlMode            =   23
  $XuiLabel796       =   6
  $XuiLabel797       =   7

  XgrSetGridBuffer(#CanvasGrid, 0,0,0)
  XgrGetGridWindow(#CanvasGrid, @window)
  XgrGetGridPositionAndSize(#CanvasGrid, @x, @y, @pw, @ph)
  XgrSetGridPositionAndSize(#CanvasGrid, x, y, cw, ch)
  XgrClearGrid(#CanvasGrid, #CANVAS_COLOR)
  XgrGetGridPositionAndSize(#CanvasGridClip, @wx, @wy, @ww, @wh)
  XgrSetGridPositionAndSize(#CanvasGridClip,wx,wy, ww + (cw - pw), wh + (ch - ph))

  XgrDestroyGrid(#CanvasGridBuffer)
  #CanvasGridBuffer = 0
  XgrCreateGrid(@#CanvasGridBuffer, 1, 0, 0, cw, ch, window, #CanvasGrid, 0)
  XgrClearGrid(#CanvasGridBuffer, #CANVAS_COLOR)
  XgrSetGridBuffer(#CanvasGrid, #CanvasGridBuffer, x, y)
  XgrSetGridClip(#CanvasGridBuffer, #CanvasGridClip)

  XgrGetWindowPositionAndSize(window, @wx, @wy, @ww, @wh)
  XgrSetWindowPositionAndSize(window, wx, wy, ww + (cw - pw), wh + (ch - ph))
  #WindowWidth = ww + (cw - pw)
  #WindowHeight = wh + (ch - ph)
  XuiSendMessage(#GeoFile, #GetSize, @x, @y, @nw, @nh, 0, 0)
  XuiSendMessage(#GeoFile, #SetSize, x, y, nw + (cw - pw), nh + (ch - ph), 0, 0)

  XuiSendMessage(#GeoFile, #GetSize, @x, @y, @w, @nh, $XuiLabel796, 0)
  XuiSendMessage(#GeoFile, #SetSize, x, y + (ch - ph), w, nh, $XuiLabel796, 0)

  XuiSendMessage(#GeoFile, #GetSize, @x, @y, @w, @nh, $XuiLabel797, 0)
  XuiSendMessage(#GeoFile, #SetSize, x + (cw - pw), y + (ch - ph), w, nh, $XuiLabel797, 0)

  XuiSendMessage(#GeoFile, #GetSize, @x, @y, @w, @nh, $xrbDesign, 0)
  XuiSendMessage(#GeoFile, #SetSize, x, y + (ch - ph), w, nh, $xrbDesign, 0)

  XuiSendMessage(#GeoFile, #GetSize, @x, @y, @w, @nh, $xrbDataEntry, 0)
  XuiSendMessage(#GeoFile, #SetSize, x, y + (ch - ph), w, nh, $xrbDataEntry, 0)

  XuiSendMessage(#GeoFile, #GetSize, @x, @y, @w, @nh, $xlMode, 0)
  XuiSendMessage(#GeoFile, #SetSize, x, y + (ch - ph), w, nh, $xlMode, 0)

  XuiSendMessage(window, #ResizeWindowToGrid, 0,0,0,0,0,0)
  XgrCopyImage(#CanvasGridBuffer, #CanvasGrid)
  XgrRefreshGrid(#CanvasGrid)
  XuiSendMessage(#GeoFile, #Redraw,0,0,0,0,0,0)
  XuiSendMessage(window, #Redraw,0,0,0,0,0,0)
  XuiSendMessage(#CanvasGrid, #Redraw,0,0,0,0,0,0)

END FUNCTION

' ##############################
' #####  CopyImageFile ()  #####
' ##############################
'
' Copy selected image file into the projects image directory
'
FUNCTION  CopyImageFile (file$, @name$, move)
  XstDecomposePathname(@file$, @path$, @drive$, @name$, @filename$, @extent$)
  i$ = #CurrentProject$ + $$PathSlash$ + $$STATIC_IMAGE_DIR$
  IF(path$ == i$) THEN RETURN $$TRUE
  err = XstCopyFile(file$, i$ + $$PathSlash$ + name$)
  IF(err != 0) THEN
    Log($$LOG_ERROR, "CopyImageFile() could not copy image file!")
    Log($$LOG_ERROR, file$)
    ShowMessage("Could not copy image to image directory!")
    RETURN $$FALSE
  ELSE
    IF(move) THEN
      err = XstDeleteFile(file$)
      IF(err != 0) THEN
        Log($$LOG_INFO, "Could not delete " + file$)
      ELSE
        Log($$LOG_INFO, "Moved file " + file$)
      END IF
    END IF
  END IF

  RETURN $$TRUE
END FUNCTION

' #################################
' #####  MakeFieldVisible ()  #####
' #################################
'
' Force the field to be within the canvas area
' Right now, it just sticks the thing in the corner.
'
FUNCTION  MakeFieldVisible (index, type)
  SHARED FIELD FieldList[]
  SHARED FIELD LabelList[]
  POINT delta

  SELECT CASE type
    CASE $$ENTRY        : GOSUB AddField
    CASE $$LABEL        : GOSUB AddLabel
    CASE $$IMAGE        : GOSUB AddLabel
    CASE $$STATIC_IMAGE : GOSUB AddLabel
  END SELECT


  SUB AddField
    delta.x = 10 - FieldList[index].x
    delta.y = 10 - FieldList[index].y
    MoveObject(FieldList[index].grid, index, $$ENTRY, delta)
  END SUB

  SUB AddLabel
    delta.x = 10 - LabelList[index].x
    delta.y = 10 - LabelList[index].y
    MoveObject(FieldList[index].grid, index, $$LABEL, delta)
  END SUB
END FUNCTION

' ##########################
' #####  DrawRuler ()  #####
' ##########################
'
FUNCTION  DrawRuler (action, mode)
  pixel = 0
  height = 0
  grid = #CanvasGridClip
  z = 0
  mark = 0

  SELECT CASE mode
    CASE $$RULER_MODE_INCHES:  pixel = #DPI_X / 8
    CASE $$RULER_MODE_CM: pixel = 28
    CASE $$RULER_MODE_PX: pixel = 10
  END SELECT

  XgrGetGridPositionAndSize(grid, @x, @y, @w, @h)

  horizontal = $$TRUE
  FOR i = 0 TO w - #RulerWidth - 1
    IF(i MOD pixel == 0) THEN
      SELECT CASE mode
        CASE $$RULER_MODE_INCHES: GOSUB DrawTickInches
        CASE $$RULER_MODE_CM:     GOSUB DrawTickCm
        CASE $$RULER_MODE_PX:     GOSUB DrawTickPx
      END SELECT
    END IF
  NEXT i

  z = 0
  mark = 0

  horizontal = $$FALSE
  FOR i = 0 TO h - #RulerHeight - 1
    IF(i MOD pixel == 0) THEN
      SELECT CASE mode
        CASE $$RULER_MODE_INCHES: GOSUB DrawTickInches
        CASE $$RULER_MODE_CM:     GOSUB DrawTickCm
        CASE $$RULER_MODE_PX:     GOSUB DrawTickPx
      END SELECT
    END IF
  NEXT i

  SUB DrawTickInches
    SELECT CASE TRUE
      CASE z = 0        : height = 18
      CASE z = 2, z = 6 : height = 8
      CASE z = 4        : height = 13
      CASE z = 8        :
        height = 18
        INC mark
        IF(horizontal) THEN
          IF(mark > 9) THEN
            offset = 16
          ELSE
            offset = 8
          END IF
          XgrSetDrawpointGrid(grid, i + #RulerWidth - offset, 8)
          XgrDrawTextGrid(grid, $$RULER_TEXT_COLOR, STRING$(mark))
        ELSE
          XgrSetDrawpointGrid(grid, 10, i + #RulerHeight - 11)
          XgrDrawTextGrid(grid, $$RULER_TEXT_COLOR, STRING$(mark))
        END IF
      CASE ELSE         : height = 5
    END SELECT

    IF(horizontal) THEN
      XgrDrawLineGrid(grid, $$RULER_TICK_COLOR, i + #RulerWidth, 0, i + #RulerWidth, height)
    ELSE
      XgrDrawLineGrid(grid, $$RULER_TICK_COLOR, 0, i + #RulerHeight, height, i + #RulerHeight)
    END IF

    INC z
    IF z > 8 THEN z = 1
  END SUB

  SUB DrawTickCm
    height = 13
    IF(z MOD 2 == 0) THEN
      INC mark
      IF(horizontal) THEN
        XgrSetDrawpointGrid(grid, i + #RulerWidth - 8, 10)
        XgrDrawTextGrid(grid, $$RULER_TEXT_COLOR, STRING$(mark))
      ELSE
        XgrSetDrawpointGrid(grid, 10, i + #RulerHeight - 12)
        XgrDrawTextGrid(grid, $$RULER_TEXT_COLOR, STRING$(mark))
      END IF
    END IF
    IF(horizontal) THEN
      XgrDrawLineGrid(grid, $$RULER_TICK_COLOR, i + #RulerWidth, 0, i + #RulerWidth, height)
    ELSE
      XgrDrawLineGrid(grid, $$RULER_TICK_COLOR, 0, i + #RulerHeight, height, i + #RulerHeight)
    END IF
    INC z
    IF z > 2 THEN z = 1
  END SUB

  SUB DrawTickPx
    height = 18
    IF(z > 0 && z MOD 4 == 0) THEN
      mark = z * pixel
      mark$ = STRING$(mark)
      IF(horizontal) THEN
        XgrSetDrawpointGrid(grid, i + #RulerWidth - (LEN(mark$) * 7), 1)
        XgrDrawTextGrid(grid, $$RULER_TEXT_COLOR, mark$)
        XgrDrawLineGrid(grid, $$RULER_TICK_COLOR, i + #RulerWidth, 0, i + #RulerWidth, height)
      ELSE
        XgrSetDrawpointGrid(grid, 1, i + #RulerHeight - 13)
        XgrDrawTextGrid(grid, $$RULER_TEXT_COLOR, mark$)
        XgrDrawLineGrid(grid, $$RULER_TICK_COLOR, 0, i + #RulerHeight, height, i + #RulerHeight)
      END IF
    ELSE
      IF(horizontal) THEN
        XgrDrawLineGrid(grid, $$RULER_TICK_COLOR, i + #RulerWidth, height - height/4, i + #RulerWidth, height)
      ELSE
        XgrDrawLineGrid(grid, $$RULER_TICK_COLOR, #RulerWidth - #RulerWidth/4, i + #RulerHeight, height, i + #RulerHeight)
      END IF
    END IF
    INC z
  END SUB
END FUNCTION

' ############################
' #####  UpdateRuler ()  #####
' ############################
'
FUNCTION  UpdateRuler (action, check)
  STATIC XLONG oldx
  STATIC XLONG oldy
  $guideSize = 10

  IF(action == $$RULER_CLEAR) THEN
    GOSUB ClearAll
    RETURN
  END IF

  IF(check) THEN
    XgrGetMouseInfo(@window, @grid, @x, @y, 0, 0)
    IF(window != #GeoFileWin) THEN RETURN
    IF(grid == #CanvasGridClip || grid == #GeoFile || grid <= 0) THEN
      RETURN
    END IF
  END IF

  'Mess around getting the right x,y based on what grid the mouse is in
  IF(grid != #CanvasGrid) THEN
    IF(#SelectedGrid > 0) THEN
      grid = #SelectedGrid
    ELSE
      XuiGetEnclosingGrid(grid, #GetEnclosingGrid, @egrid,0,0,0,0,0)
      IF(GetFieldByGrid(egrid, @index)) THEN
        grid = egrid
      ELSE
        IF(egrid != #CanvasGrid) THEN RETURN
      END IF
    END IF
    XgrGetGridPositionAndSize(grid, @x1, @y1, 0, 0)
    x = x1 + x
    y = y1 + y
  END IF
  IFZ(oldx) THEN oldx = x
  IFZ(oldy) THEN oldy = y
  SELECT CASE action
    CASE $$RULER_DRAW:
      GOSUB ClearCaret
      DrawRuler($$RULER_DRAW, #RulerMode)
      GOSUB DrawCaret
    CASE $$RULER_DRAW_BOX:
      GOSUB ClearAll
      GOSUB DrawRect
      DrawRuler($$RULER_DRAW, #RulerMode)
  END SELECT
  RETURN

  SUB DrawCaret
   XgrDrawLineGrid(#CanvasGridClip, $$RULER_CARET_COLOR, x + #RulerWidth, 1, x + #RulerWidth, #RulerHeight - 1)
   XgrDrawLineGrid(#CanvasGridClip, $$RULER_CARET_COLOR, 1, y + #RulerHeight, #RulerWidth - 1, y + #RulerHeight)
  END SUB

  SUB DrawRect
    XgrGetGridPositionAndSize(#SelectedGrid, @x, @y, @w, @h)
    XgrFillBoxGrid(#CanvasGridClip, $$RULER_CARET_COLOR, x + #RulerWidth, 1, x + #RulerWidth + w, #RulerHeight)
    XgrFillBoxGrid(#CanvasGridClip, $$RULER_CARET_COLOR, 1, y + #RulerHeight, #RulerWidth, y + h + #RulerHeight)
  END SUB

  SUB ClearCaret
    XgrGetGridPositionAndSize(#CanvasGridClip, 0,0, @w, @h)
    xc = x + #RulerWidth
    yc = y + #RulerHeight
    IF(xc >= oldx) THEN
      XgrFillBoxGrid(#CanvasGridClip, $$RULER_COLOR, oldx, 1, xc, #RulerHeight)
    ELSE
      XgrFillBoxGrid(#CanvasGridClip, $$RULER_COLOR, xc, 1, oldx, #RulerHeight)
    END IF
    IF(yc >= oldy) THEN
      XgrFillBoxGrid(#CanvasGridClip, $$RULER_COLOR, 1, oldy, #RulerWidth, yc)
    ELSE
      XgrFillBoxGrid(#CanvasGridClip, $$RULER_COLOR, 1, yc, #RulerWidth, oldy)
    END IF
    oldx = xc : oldy = yc
  END SUB

  SUB ClearAll
    XgrGetGridPositionAndSize(#CanvasGridClip, 0,0,@w,@h)
    XgrFillBoxGrid(#CanvasGridClip, $$RULER_COLOR, #RulerWidth, 1, w - 2, #RulerHeight)
    XgrFillBoxGrid(#CanvasGridClip, $$RULER_COLOR, 1, #RulerHeight, #RulerWidth, h - 2 )
  END SUB

END FUNCTION

'Very basic slide show support.
FUNCTION SlideShow(timer, @count, msec, time)
  IF(#ShowOnlyMarked) THEN
    record = GetNextRecord(GetOrderIndex(#CurrentRecord), $$GET_MARKED)
  ELSE
    record = GetNextRecord(GetOrderIndex(#CurrentRecord), $$GET_ORDINAL)
  END IF
  IF(record == -1) THEN
    Log($$LOG_INFO, "Slide Show ended.")
    #SlideShow = $$FALSE
    #SlideShowTimer = 0
    RETURN
  ELSE
    #CurrentRecord = record
  END IF
  Log($$LOG_INFO, "Showing next slide")
  DisplayRecord(record, $$TRUE)
  INC count
END FUNCTION

'	###########################
'	#####  FieldOrder ()  #####
'	###########################
'
FUNCTION  FieldOrder (grid, message, v0, v1, v2, v3, r0, (r1, r1$, r1[], r1$[]))
	STATIC  designX,  designY,  designWidth,  designHeight
	STATIC  SUBADDR  sub[]
	STATIC  upperMessage
	STATIC  FieldOrder
	$FieldOrder   =   0  ' kid   0 grid type = FieldOrder
	$XuiLabel783  =   1  ' kid   1 grid type = XuiLabel
	$XuiLabel784  =   2  ' kid   2 grid type = XuiLabel
	$xlFieldList  =   3  ' kid   3 grid type = XuiList
	$xpbMoveUp    =   4  ' kid   4 grid type = XuiPushButton
	$xpbMoveDown  =   5  ' kid   5 grid type = XuiPushButton
	$XuiLabel791  =   6  ' kid   6 grid type = XuiLabel
	$xpbOk        =   7  ' kid   7 grid type = XuiPushButton
	$xpbReset     =   8  ' kid   8 grid type = XuiPushButton
	$xpbCancel    =   9  ' kid   9 grid type = XuiPushButton
	$UpperKid     =   9  ' kid maximum

	IFZ sub[] THEN GOSUB Initialize
	IF XuiProcessMessage (grid, message, @v0, @v1, @v2, @v3, @r0, @r1, FieldOrder) THEN RETURN
	IF (message <= upperMessage) THEN GOSUB @sub[message]
	RETURN

  SUB Callback
    message = r1
    callback = message
    IF (message <= upperMessage) THEN GOSUB @sub[message]
  END SUB

  SUB Create
    IF (v0 <= 0) THEN v0 = 0
    IF (v1 <= 0) THEN v1 = 0
    IF (v2 <= 0) THEN v2 = designWidth
    IF (v3 <= 0) THEN v3 = designHeight
    XuiCreateGrid  (@grid, FieldOrder, @v0, @v1, @v2, @v3, r0, r1, &FieldOrder())
    XuiSendMessage ( grid, #SetGridName, 0, 0, 0, 0, 0, @"FieldOrder")
    XuiLabel       (@g, #Create, 0, 0, 234, 284, r0, grid)
    XuiSendMessage ( g, #SetCallback, grid, &FieldOrder(), -1, -1, $XuiLabel783, grid)
    XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"XuiLabel783")
    XuiSendMessage ( g, #SetBorder, $$BorderValley, $$BorderValley, $$BorderNone, 0, 0, 0)
    XuiLabel       (@g, #Create, 0, 284, 234, 40, r0, grid)
    XuiSendMessage ( g, #SetCallback, grid, &FieldOrder(), -1, -1, $XuiLabel784, grid)
    XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"XuiLabel784")
    XuiSendMessage ( g, #SetBorder, $$BorderValley, $$BorderValley, $$BorderNone, 0, 0, 0)
    XuiList        (@g, #Create, 10, 20, 214, 204, r0, grid)
    XuiSendMessage ( g, #SetCallback, grid, &FieldOrder(), -1, -1, $xlFieldList, grid)
    XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xlFieldList")
    XuiSendMessage ( g, #SetStyle, 0, 0, 0, 0, 0, 0)
    XuiSendMessage ( g, #SetBorder, $$BorderLower1, $$BorderLower1, $$BorderNone, 0, 0, 0)
    XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 1, @"List")
    XuiSendMessage ( g, #SetColor, $$White, $$Black, $$Black, $$White, 1, 0)
    XuiSendMessage ( g, #SetColorExtra, $$Grey, $$Green, $$Black, $$White, 1, 0)
    XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 2, @"ScrollH")
    XuiSendMessage ( g, #SetStyle, 2, 0, 0, 0, 2, 0)
    XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 3, @"ScrollV")
    XuiSendMessage ( g, #SetStyle, 2, 0, 0, 0, 3, 0)
    XuiPushButton  (@g, #Create, 156, 236, 32, 28, r0, grid)
    XuiSendMessage ( g, #SetCallback, grid, &FieldOrder(), -1, -1, $xpbMoveUp, grid)
    XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xpbMoveUp")
    XuiSendMessage ( g, #SetHintString,0,0,0,0,0,"Move selected field up")
    XuiSendMessage ( g, #SetImage, 0,0,0,0,0, "." + $$PathSlash$ + "images" + $$PathSlash$ + "move_up.bmp")
    XuiPushButton  (@g, #Create, 192, 236, 32, 28, r0, grid)
    XuiSendMessage ( g, #SetCallback, grid, &FieldOrder(), -1, -1, $xpbMoveDown, grid)
    XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xpbMoveDown")
    XuiSendMessage ( g, #SetImage, 0,0,0,0,0, "." + $$PathSlash$ + "images" + $$PathSlash$ + "move_down.bmp")
    XuiSendMessage ( g, #SetHintString,0,0,0,0,0,"Move selected field down")
    XuiLabel       (@g, #Create, 8, 240, 144, 24, r0, grid)
    XuiSendMessage ( g, #SetCallback, grid, &FieldOrder(), -1, -1, $XuiLabel791, grid)
    XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"XuiLabel791")
    XuiSendMessage ( g, #SetBorder, $$BorderNone, $$BorderNone, $$BorderNone, 0, 0, 0)
    XuiSendMessage ( g, #SetTexture, $$TextureNone, 0, 0, 0, 0, 0)
    XuiSendMessage ( g, #SetFont, 200, 400, 0, 0, 0, @"Terminal")
    XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"Change Field Order")
    XuiPushButton  (@g, #Create, 32, 292, 60, 24, r0, grid)
    XuiSendMessage ( g, #SetCallback, grid, &FieldOrder(), -1, -1, $xpbOk, grid)
    XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xpbOk")
    XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"Ok")
    XuiPushButton  (@g, #Create, 92, 292, 60, 24, r0, grid)
    XuiSendMessage ( g, #SetCallback, grid, &FieldOrder(), -1, -1, $xpbReset, grid)
    XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xpbReset")
    XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"Reset")
    XuiPushButton  (@g, #Create, 152, 292, 60, 24, r0, grid)
    XuiSendMessage ( g, #SetCallback, grid, &FieldOrder(), -1, -1, $xpbCancel, grid)
    XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xpbCancel")
    XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"Cancel")
    GOSUB Resize
  END SUB

  SUB CreateWindow
    IF (v0 == 0) THEN v0 = designX
    IF (v1 == 0) THEN v1 = designY
    IF (v2 <= 0) THEN v2 = designWidth
    IF (v3 <= 0) THEN v3 = designHeight
    XuiWindow (@window, #WindowCreate, v0, v1, v2, v3, r0, @r1$)
    v0 = 0 : v1 = 0 : r0 = window : ATTACH r1$ TO display$
    GOSUB Create
    r1 = 0 : ATTACH display$ TO r1$
    XuiWindow (window, #WindowRegister, grid, -1, v2, v3, @r0, @"FieldOrder")
  END SUB

  SUB GetSmallestSize
  END SUB

  SUB Redrawn
    XuiCallback (grid, #Redrawn, v0, v1, v2, v3, r0, r1)
  END SUB

  SUB Resize
  END SUB

  SUB Selection
  END SUB

  SUB Initialize
    XuiGetDefaultMessageFuncArray (@func[])
    XgrMessageNameToNumber (@"LastMessage", @upperMessage)
  '
    func[#Callback]           = &XuiCallback ()
  ' func[#GetSmallestSize]    = 0                             ' enable to add internal GetSmallestSize routine
  ' func[#Resize]             = 0                             ' enable to add internal Resize routine
  '
    DIM sub[upperMessage]
  '	sub[#Callback]            = SUBADDRESS (Callback)         ' enable to handle Callback messages internally
    sub[#Create]              = SUBADDRESS (Create)           ' must be subroutine in this function
    sub[#CreateWindow]        = SUBADDRESS (CreateWindow)     ' must be subroutine in this function
  '	sub[#GetSmallestSize]     = SUBADDRESS (GetSmallestSize)  ' enable to add internal GetSmallestSize routine
    sub[#Redrawn]             = SUBADDRESS (Redrawn)          ' generate #Redrawn callback if appropriate
  '	sub[#Resize]              = SUBADDRESS (Resize)           ' enable to add internal Resize routine
    sub[#Selection]           = SUBADDRESS (Selection)        ' routes Selection callbacks to subroutine
  '
    IF sub[0] THEN PRINT "FieldOrder() : Initialize : error ::: (undefined message)"
    IF func[0] THEN PRINT "FieldOrder() : Initialize : error ::: (undefined message)"
    XuiRegisterGridType (@FieldOrder, "FieldOrder", &FieldOrder(), @func[], @sub[])

    designX = 612
    designY = 71
    designWidth = 234
    designHeight = 324
  '
    gridType = FieldOrder
    XuiSetGridTypeProperty (gridType, @"x",                designX)
    XuiSetGridTypeProperty (gridType, @"y",                designY)
    XuiSetGridTypeProperty (gridType, @"width",            designWidth)
    XuiSetGridTypeProperty (gridType, @"height",           designHeight)
    XuiSetGridTypeProperty (gridType, @"maxWidth",         designWidth)
    XuiSetGridTypeProperty (gridType, @"maxHeight",        designHeight)
    XuiSetGridTypeProperty (gridType, @"minWidth",         designWidth)
    XuiSetGridTypeProperty (gridType, @"minHeight",        designHeight)
    XuiSetGridTypeProperty (gridType, @"can",              $$Focus OR $$Respond OR $$Callback)
    XuiSetGridTypeProperty (gridType, @"focusKid",         $xlFieldList)
    IFZ message THEN RETURN
  END SUB
END FUNCTION

' ###############################
' #####  FieldOrderCode ()  #####
' ###############################
'
FUNCTION  FieldOrderCode (grid, message, v0, v1, v2, v3, kid, r1)
  FIELD temp_field
  FIELD field_list[]
  SHARED FIELD FieldList[]
	$FieldOrder   =   0  ' kid   0 grid type = FieldOrder
	$XuiLabel783  =   1  ' kid   1 grid type = XuiLabel
	$XuiLabel784  =   2  ' kid   2 grid type = XuiLabel
	$xlFieldList  =   3  ' kid   3 grid type = XuiList
	$xpbMoveUp    =   4  ' kid   4 grid type = XuiPushButton
	$xpbMoveDown  =   5  ' kid   5 grid type = XuiPushButton
	$XuiLabel791  =   6  ' kid   6 grid type = XuiLabel
	$xpbOk        =   7  ' kid   7 grid type = XuiPushButton
	$xpbReset     =   8  ' kid   8 grid type = XuiPushButton
	$xpbCancel    =   9  ' kid   9 grid type = XuiPushButton
	$UpperKid     =   9  ' kid maximum

	IF (message == #Callback) THEN message = r1

	SELECT CASE message
    CASE #Notify      : GOSUB Update
		CASE #Selection		: GOSUB Selection
		CASE #CloseWindow	: XuiSendMessage (grid, #HideWindow, 0, 0, 0, 0, 0, 0)
	END SELECT
	RETURN

  SUB Update
		GetFieldNames(@#Buff$[])
    XuiSendMessage(#FieldOrder, #SetTextArray, 0,0,0,0,$xlFieldList,@#Buff$[])
    XuiSendMessage(#FieldOrder, #RedrawText,0,0,0,0,$xlFieldList,0)
  END SUB

  SUB Selection
	  SELECT CASE kid
		  CASE $xpbMoveUp    : GOSUB MoveUp
		  CASE $xpbMoveDown  : GOSUB MoveDown
		  CASE $xpbOk        : GOSUB SetFieldOrder
	    CASE $xpbReset     : GOSUB Update
		  CASE $xpbCancel    : XuiSendMessage(#FieldOrder, #HideWindow,0,0,0,0,0,0)
	  END SELECT
  END SUB

  SUB MoveUp
    XuiSendMessage(#FieldOrder, #GetValues, @v0,@v1,@v2,@v3, $xlFieldList,0)
    IF(v3 == 0) THEN
      EXIT SUB
    END IF
    XuiSendMessage(#FieldOrder, #GetTextArrayLine, v3,0,0,0, $xlFieldList, @sel$)
    XuiSendMessage(#FieldOrder, #GetTextArrayLine, v3 - 1 ,0,0,0, $xlFieldList, @temp$)
    XuiSendMessage(#FieldOrder, #SetTextArrayLine, v3 - 1, 0,0,0, $xlFieldList, @sel$)
    XuiSendMessage(#FieldOrder, #SetTextArrayLine, v3, 0,0,0, $xlFieldList, @temp$)
    XuiSendMessage(#FieldOrder, #SetValues, v0,v1,v2,v3-1, $xlFieldList,0)
    XuiSendMessage(#FieldOrder, #RedrawText,0,0,0,0,$xlFieldList,0)
  END SUB

  SUB MoveDown
    XuiSendMessage(#FieldOrder, #GetValues, @v0,@v1,@v2,@v3, $xlFieldList,0)
    XuiSendMessage(#FieldOrder, #GetTextArrayLine, v3,0,0,@upper, $xlFieldList, @sel$)
    IF(v3 == upper) THEN
      EXIT SUB
    END IF
    XuiSendMessage(#FieldOrder, #GetTextArrayLine, v3 + 1 ,0,0,0, $xlFieldList, @temp$)
    XuiSendMessage(#FieldOrder, #SetTextArrayLine, v3 + 1, 0,0,0, $xlFieldList, @sel$)
    XuiSendMessage(#FieldOrder, #SetTextArrayLine, v3, 0,0,0, $xlFieldList, @temp$)
    XuiSendMessage(#FieldOrder, #SetValues, v0,v1,v2,v3+1, $xlFieldList,0)
    XuiSendMessage(#FieldOrder, #RedrawText,0,0,0,0,$xlFieldList,0)
  END SUB

  SUB SetFieldOrder
    REDIM #Buff$[]
    REDIM #Buff[]
    temp$ = "Unsaved records will be saved\nand the project reloaded."
    temp$ = temp$ + "\nWould you like to proceed?"
    IF(AskYesNo(@temp$) == $$FALSE) THEN EXIT SUB
    XuiSendMessage(#FieldOrder, #HideWindow, 0,0,0,0,0,0)
    GetDirtyRecords(@#Buff[])
    IF(#Buff[]) THEN SaveRecords(@#Buff[])
    XuiSendMessage(#FieldOrder, #GetTextArray, 0,0,0,0, $xlFieldList, @#Buff$[])
    IF(SQL_ReorderColumns(@#Buff$[])) THEN
      temp$ = #GeoFile$
      SaveLayout(#CurrentLayout$)
      GOSUB ReorderLayouts
      'This is a problem is field validation fails!
      CloseProject($$FALSE, $$FALSE)
      OpenProject(temp$)
    END IF
  END SUB

  SUB ReorderLayouts
    GetLayouts(@layouts$[])
    DIM field_list[UBOUND(FieldList[])]

    FOR z = 0 TO UBOUND(layouts$[])
      file$ = #CurrentProject$ + $$PathSlash$ + layouts$[z]
      fd = OPEN(file$, $$RD)

      IF(fd <= 0) THEN
        Log($$LOG_INFO, "ReorderLayouts: Could not open layout " + file$)
        ShowMessage("Could not load: " + file$)
        DO NEXT
      END IF

      'Read the fields
      READ [fd], fields
      FOR i = 0 TO fields - 1
        READ [fd], temp_field
        field_list[i] = temp_field
      NEXT i
      CLOSE(fd)

      'Re-set summary field indices
      FOR i = 0 TO UBOUND(field_list[])
        IF(GetSummaryField(i, @field)) THEN
          FOR z = 0 TO UBOUND(#Buff$[])
            IF(field_list[i].name == #Buff$[z]) THEN
              Log($$LOG_DEBUG, "Re-assigning summary field: " + field_list[field].name)
              Log($$LOG_DEBUG, "to index: " + STRING$(z))
              field_list[field].max = z
            END IF
          NEXT z
        END IF
      NEXT i

      'Write the fields in the new order
      fd = OPEN(file$, $$WR)
      WRITE [fd], fields
      FOR p = 0 TO UBOUND(#Buff$[])
        FOR i = 0 TO UBOUND(field_list[])
          IF(field_list[i].name == #Buff$[p]) THEN
            temp_field = field_list[i]
            WRITE [fd], temp_field
            EXIT FOR
          END IF
        NEXT i
      NEXT p
      CLOSE(fd)
    NEXT z
  END SUB

END FUNCTION

' ###################################
' #####  SQL_ReorderColumns ()  #####
' ###################################
'
' TODO: This shares a bunch of code with SQL_DeleteColumn(),
' so should probably be combined with that somehow.
'
FUNCTION  SQL_ReorderColumns (columns$[])
  cols$ = "geofile_id, "
  FOR i = 0 TO UBOUND(columns$[])
    cols$ = cols$ + columns$[i]
    IF(i < UBOUND(columns$[])) THEN
      cols$ = cols$ + ", "
    END IF
  NEXT i

  sql$ = "CREATE TEMPORARY TABLE backup(" + cols$ + "); "
  sql$ = sql$ + "INSERT INTO backup SELECT " + cols$ + " FROM " + #TableName$ +"; "
  sql$ = sql$ + "DROP TABLE " + #TableName$ + "; "
  sql$ = sql$ + "CREATE TABLE " + #TableName$ + "(" + cols$ + "); "
  sql$ = sql$ + "INSERT INTO " + #TableName$ + " SELECT " + cols$ + " "
  sql$ = sql$ + "FROM backup; "
  sql$ = sql$ + "DROP TABLE backup; "

  Log($$LOG_INFO, sql$)

  ret = sqlite3_exec(#DB, &sql$, &SQLCallback(), $$DB_REORDER_COLUMNS, &err)

  IF(ret <> 0) THEN
    err$ = CSTRING$(err)
    ShowMessage(err$)
    RETURN $$FALSE
  END IF

  RETURN $$TRUE

END FUNCTION

FUNCTION DeleteSelectedLabels(SEL_LIST list[])

  IFZ(list[]) THEN RETURN $$FALSE

  'Reject if any fields are selected
  FOR i = 0 TO UBOUND(list[])
    IF(GetFieldByGrid(list[i].grid, @index)) THEN
      ShowMessage("Plese de-selected all\nfields before deleting!")
      RETURN $$FALSE
    END IF
  NEXT i

  FOR i = 0 TO UBOUND(list[])
    IF(GetLabelByGrid(list[i].grid, @index)) THEN
       DeleteLabel(index)
    END IF
  NEXT i

  RETURN $$TRUE
END FUNCTION

FUNCTION QuitProgram()
  IFZ(CloseProject($$TRUE, $$TRUE)) THEN RETURN
  QUIT(0)
END FUNCTION

FUNCTION ResizeField(index, step, which)
  SHARED FIELD FieldList[]

  XuiSendMessage(FieldList[index].grid, #GetFontMetrics, @font_width, @font_height, 0, 0, 0, 0)
  IF(which == 0) THEN
    XgrGetGridPositionAndSize(FieldList[index].grid, @x, @y, @w, @h)
    IF(step < 0 && (w - 2 + step) <= font_width) THEN RETURN $$FALSE
    IF(step > 0 && (x + w + step) >= #PageWidth) THEN RETURN $$FALSE
    XgrSetGridPositionAndSize(FieldList[index].grid, x, y, w + step, h)
    SELECT CASE TRUE
      CASE FieldList[index].type >= $$FT_STRING_SINGLE && FieldList[index].type <= $$FT_SUMMARY:
        XuiGetKidArray(FieldList[index].grid, #GetKidArray, 0,0,0,0,0, @kids[])
        XgrGetGridPositionAndSize(kids[1], @x, @y, @w, @h)
        XgrSetGridPositionAndSize(kids[1], x, y, w + step, h)
    END SELECT
    FieldList[index].w = FieldList[index].w + step
    IF(FieldList[index].type == $$FT_IMAGE) THEN
      FieldList[index].min = w
    END IF
    XuiSendMessage(#CanvasGrid, #Redraw, x, y, w, h,0,0)
  ELSE
    XgrGetGridPositionAndSize(FieldList[index].grid, @x, @y, @w, @h)
    IF(step < 0 && (h - 2 + step) <= font_height) THEN RETURN $$FALSE
    IF(step > 0 && (y + h + step) >= #PageHeight) THEN RETURN $$FALSE
    XgrSetGridPositionAndSize(FieldList[index].grid, x, y, w, h + step)
    SELECT CASE FieldList[index].type
      CASE $$FT_STRING_MULTI:
        XuiGetKidArray(FieldList[index].grid, #GetKidArray, 0,0,0,0,0,@kids[])
        XgrGetGridPositionAndSize(kids[1], @x, @y, @w, @h)
        XgrSetGridPositionAndSize(kids[1], x, y, w, h + step)
      CASE ELSE:
        'Causes text to re-align to middle of field.
        XuiSendMessage(FieldList[index].grid, #GetFontNumber, @x, 0,0,0,0,0)
        XuiSendMessage(FieldList[index].grid, #SetFontNumber, x, 0,0,0,0,0)
    END SELECT
    FieldList[index].h = FieldList[index].h + step
    IF(FieldList[index].type == $$FT_IMAGE) THEN
      FieldList[index].max = h
    END IF
    XuiSendMessage(#CanvasGrid, #Redraw, x, y, w, h,0,0)
  END IF

END FUNCTION

'Yes, this is ugly and rediculous.  But it does the job
FUNCTION EvaluateExpression(exp$[])
  SHARED RECORD RecordList[]
  SHARED StringData$[]
  SHARED FIELD FieldList[]
  DOUBLE value
  DIM found[]
  DIM records[]

  count = 0
  field = 0
  opr = 1
  val = 2
  And = $$FALSE
  Or = $$FALSE
  remove = $$FALSE

  'Unmark all records first.
  GetMarkedRecords(@#Buff[])
  FOR i = 0 TO UBOUND(#Buff[])
    MarkRecord(#Buff[i], $$FALSE)
  NEXT i

  'Determine if there is a logical operator
  upper = UBOUND(exp$[])
  IF(upper == 6) THEN
    SELECT CASE exp$[3]
      CASE "AND" : And = $$TRUE
      CASE "OR"  : Or = $$TRUE
    END SELECT
  END IF

  'First, copy all records to record[] array
  REDIM records[UBOUND(RecordList[])]
  FOR i = 0 TO UBOUND(RecordList[])
    records[i] = i
  NEXT i
  'Evaluate first expression
  GOSUB DoEvaluate

  'Evaluate second expression
  IF(And || Or) THEN
    field = 4
    opr = 5
    val = 6
    'Only need to check already found records for AND
    SELECT CASE TRUE
      CASE And:
        remove = $$TRUE
        REDIM records[]
        XstCopyArray(@found[], @records[])
        GOSUB DoEvaluate
        XstCopyArray(@records[], @found[])
      CASE Or:
        GOSUB DoEvaluate
    END SELECT
  END IF

  'Mark the records that have been found
  FOR i = 0 TO UBOUND(found[])
    IF(found[i] != -1) THEN
      GOSUB MarkFound
    END IF
  NEXT i

  Log($$LOG_INFO, STR$(count) + " records marked")
  IF(count == 0) THEN
    ShowMessage("No Records Found!")
  END IF
  RETURN

  '#### SUBS ######
  SUB DoEvaluate
    GetFieldByName(exp$[field], @index)
    FOR i = 0 TO UBOUND(records[])
      value$ = StringData$[RecordList[records[i]].first + index]
      SELECT CASE FieldList[index].type
        CASE $$FT_INTEGER: value = DOUBLE(value$)
        CASE $$FT_REAL   : value = DOUBLE(value$)
        CASE $$FT_SUMMARY: value = DOUBLE(value$)
        CASE $$FT_DATE:
          Tokenize(value$, @out$[], $$DATE_DELIMITERS$)
          XstDateAndTimeToFileTime(XLONG(out$[2]), XLONG(out$[0]), XLONG(out$[1]), 0, 0, 0, 0, 0, @value$$)
      END SELECT
      SELECT CASE exp$[opr]
        CASE "="  : GOSUB Equals
        CASE ">=" : GOSUB GreaterEqual
        CASE ">"  : GOSUB Greater
        CASE "<"  : GOSUB Less
        CASE "<=" : GOSUB LessEqual
      END SELECT
    NEXT i
  END SUB

  SUB GreaterEqual
    SELECT CASE FieldList[index].type
      CASE $$FT_INTEGER, $$FT_REAL, $$FT_SUMMARY:
        IF(value >= DOUBLE(exp$[val])) THEN
          GOSUB AddToFound
        ELSE
          IF(remove) THEN records[i] = -1
        END IF
      CASE $$FT_DATE:
        Tokenize(exp$[val], @out$[], $$DATE_DELIMITERS$)
        IF(UBOUND(out$[]) != 2) THEN EXIT SUB
        XstDateAndTimeToFileTime(XLONG(out$[2]), XLONG(out$[0]), XLONG(out$[1]), 0, 0, 0, 0, 0, @value2$$)
        IF(value$$ >= value2$$) THEN
          GOSUB AddToFound
        ELSE
          IF(remove) THEN records[i] = -1
        END IF
      CASE ELSE:
        temp$ = exp$[val]
        IF(XstCompareStrings(&value$, $$GE, &temp$, 0)) THEN
          GOSUB AddToFound
         ELSE
          IF(remove) THEN records[i] = -1
        END IF
    END SELECT
  END SUB

  SUB Greater
    SELECT CASE FieldList[index].type
      CASE $$FT_INTEGER, $$FT_REAL, $$FT_SUMMARY:
        IF(value > DOUBLE(exp$[val])) THEN
          GOSUB AddToFound
        ELSE
          IF(remove) THEN records[i] = -1
        END IF
      CASE $$FT_DATE:
        Tokenize(exp$[val], @out$[], $$DATE_DELIMITERS$)
        IF(UBOUND(out$[]) != 2) THEN EXIT SUB
        XstDateAndTimeToFileTime(XLONG(out$[2]), XLONG(out$[0]), XLONG(out$[1]), 0, 0, 0, 0, 0, @value2$$)
        IF(value$$ > value2$$) THEN
          GOSUB AddToFound
        ELSE
          IF(remove) THEN records[i] = -1
        END IF
      CASE ELSE:
        temp$ = exp$[val]
        IF(XstCompareStrings(&value$, $$GT, &temp$, 0)) THEN
          GOSUB AddToFound
        ELSE
          IF(remove) THEN records[i] = -1
        END IF
    END SELECT
  END SUB

  SUB Less
    SELECT CASE FieldList[index].type
      CASE $$FT_INTEGER, $$FT_REAL, $$FT_SUMMARY:
        IF(value < DOUBLE(exp$[val])) THEN
          GOSUB AddToFound
        ELSE
          IF(remove) THEN records[i] = -1
        END IF
      CASE $$FT_DATE:
        Tokenize(exp$[val], @out$[], $$DATE_DELIMITERS$)
        IF(UBOUND(out$[]) != 2) THEN EXIT SUB
        XstDateAndTimeToFileTime(XLONG(out$[2]), XLONG(out$[0]), XLONG(out$[1]), 0, 0, 0, 0, 0, @value2$$)
        IF(value$$ < value2$$) THEN
          GOSUB AddToFound
        ELSE
          IF(remove) THEN records[i] = -1
        END IF
      CASE ELSE:
        temp$ = exp$[val]
        IF(XstCompareStrings(&value$, $$LT, &temp$, 0)) THEN
          GOSUB AddToFound
        ELSE
          IF(remove) THEN records[i] = -1
        END IF
    END SELECT
  END SUB

  SUB LessEqual
    SELECT CASE FieldList[index].type
      CASE $$FT_INTEGER, $$FT_REAL, $$FT_SUMMARY:
        IF(value <= DOUBLE(exp$[val])) THEN
          GOSUB AddToFound
        ELSE
          IF(remove) THEN records[i] = -1
        END IF
      CASE $$FT_DATE:
        Tokenize(exp$[val], @out$[], $$DATE_DELIMITERS$)
        IF(UBOUND(out$[]) != 2) THEN EXIT SUB
        XstDateAndTimeToFileTime(XLONG(out$[2]), XLONG(out$[0]), XLONG(out$[1]), 0, 0, 0, 0, 0, @value2$$)
        IF(value$$ <= value2$$) THEN
          GOSUB AddToFound
        ELSE
          IF(remove) THEN records[i] = -1
        END IF
      CASE ELSE:
        temp$ = exp$[val]
        IF(XstCompareStrings(&value$, $$LE, &temp$, 0)) THEN
          GOSUB AddToFound
        ELSE
          IF(remove) THEN records[i] = -1
        END IF
    END SELECT
  END SUB

  SUB Equals
    SELECT CASE FieldList[index].type
      CASE $$FT_INTEGER, $$FT_REAL, $$FT_SUMMARY:
        IF(DOUBLE(exp$[val]) == value) THEN
          GOSUB AddToFound
        ELSE
          IF(remove) THEN records[i] = -1
        END IF
      CASE $$FT_DATE:
        Tokenize(exp$[val], @out$[], $$DATE_DELIMITERS$)
        IF(UBOUND(out$[]) != 2) THEN EXIT SUB
        XstDateAndTimeToFileTime(XLONG(out$[2]), XLONG(out$[0]), XLONG(out$[1]), 0, 0, 0, 0, 0, @value2$$)
        IF(value$$ == value2$$) THEN
          GOSUB AddToFound
        ELSE
          IF(remove) THEN records[i] = -1
        END IF
      CASE ELSE:
        IF(exp$[val] == value$) THEN
          GOSUB AddToFound
        ELSE
          IF(remove) THEN records[i] = -1
        END IF
    END SELECT
  END SUB

  SUB AddToFound
    Log($$LOG_DEBUG, "Adding record: " + STRING$(records[i]))
    IF(Or || And) THEN
      FOR foo = 0 TO UBOUND(found[])
        IF(found[foo] == records[i]) THEN
          Log($$LOG_DEBUG, "Record " + STRING$(records[i]) + " already in found list")
          EXIT SUB
        END IF
      NEXT foo
    END IF

    REDIM found[UBOUND(found[]) + 1]
    found[UBOUND(found[])] = records[i]
  END SUB

  SUB MarkFound
    MarkRecord(found[i], $$TRUE)
    DisplayRecord(found[i], $$TRUE)
    INC count
  END SUB

END FUNCTION

'
' ######################################
' #####  ExpressionBuilderCode ()  #####
' ######################################
'
FUNCTION  ExpressionBuilderCode (grid, message, v0, v1, v2, v3, kid, r1)
'
	$ExpressionBuilder  =   0  ' kid   0 grid type = ExpressionBuilder
	$XuiLabel787        =   1  ' kid   1 grid type = XuiLabel
	$xlFields1          =   2  ' kid   2 grid type = XuiList
	$xpdOperator1       =   3  ' kid   3 grid type = XuiPullDown
	$field1             =   4  ' kid   4 grid type = XuiLabel
	$op1                =   5  ' kid   5 grid type = XuiLabel
	$xtlValue1          =   6  ' kid   6 grid type = XuiTextLine
	$xpdLogic           =   7  ' kid   7 grid type = XuiPullDown
	$xlFields2           =   8  ' kid   8 grid type = XuiList
	$xpdOperator2       =   9  ' kid   9 grid type = XuiPullDown
	$logic              =  10  ' kid  10 grid type = XuiLabel
	$field2             =  11  ' kid  11 grid type = XuiLabel
	$op2                =  12  ' kid  12 grid type = XuiLabel
	$xtlValue2          =  13  ' kid  13 grid type = XuiTextLine
	$XuiLabel811        =  14  ' kid  14 grid type = XuiLabel
	$xpbOk              =  15  ' kid  15 grid type = XuiPushButton
	$xpbCancel          =  16  ' kid  16 grid type = XuiPushButton
	$xpbClear           =  17  ' kid  17 grid type = XuiPushButton
	$xlArrow1           =  18  ' kid  18 grid type = XuiLabel
	$xlArrow2           =  19  ' kid  19 grid type = XuiLabel
	$xlArrow3           =  20  ' kid  20 grid type = XuiLabel
	$xlArrow4           =  21  ' kid  21 grid type = XuiLabel
	$xlArrow5           =  22  ' kid  22 grid type = XuiLabel
	$UpperKid           =  22  ' kid maximum
'
	IF (message == #Callback) THEN message = r1
'
	SELECT CASE message
    CASE #Notify      : GOSUB Update
		CASE #Selection		: GOSUB Selection   	' most common callback message
		CASE #CloseWindow	: XuiSendMessage (grid, #HideWindow, 0, 0, 0, 0, 0, 0)
	END SELECT
	RETURN

  SUB Update
    GetFieldNames(@#Buff$[])
    XuiSendMessage(#ExpressionBuilder, #SetTextArray, 0,0,0,0, $xlFields1, @#Buff$[])
    XuiSendMessage(#ExpressionBuilder, #SetTextArray, 0,0,0,0, $xlFields2, @#Buff$[])
    XuiSendMessage(#ExpressionBuilder, #RedrawText, 0,0,0,0, $xlFields1, 0)
    XuiSendMessage(#ExpressionBuilder, #RedrawText, 0,0,0,0, $xlFields2, 0)
    GOSUB Clear
  END SUB

  SUB Selection
    SELECT CASE kid
      CASE $xlFields1          : GOSUB AddField
      CASE $xpdOperator1       : GOSUB AddOper
      CASE $xpdLogic           : GOSUB AddLogic
      CASE $xlFields2          : GOSUB AddField
      CASE $xpdOperator2       : GOSUB AddOper
      CASE $xpbOk              : GOSUB Evaluate
      CASE $xpbCancel          : XuiSendMessage(#ExpressionBuilder, #HideWindow, 0,0,0,0,0,0)
      CASE $xpbClear           : GOSUB Clear
    END SELECT
  END SUB

  SUB AddLogic
    IF(v0 == 2) THEN
      line$ = ""
    ELSE
      XuiSendMessage(grid, #GetTextArrayLine, v0, 0,0,0, kid, @line$)
    END IF
    XuiSendMessage(grid, #SetTextString, 0,0,0,0, $logic, @line$)
    XuiSendMessage(grid, #Redraw, 0,0,0,0, $logic, 0)
  END SUB

  SUB AddOper
    XuiSendMessage(grid, #GetTextArrayLine, v0, 0,0,0, kid, @line$)
    IF(kid == $xpdOperator1) THEN
      XuiSendMessage(grid, #SetTextString, 0,0,0,0, $op1, @line$)
      XuiSendMessage(grid, #Redraw, 0,0,0,0, $op1, 0)
    ELSE
      XuiSendMessage(grid, #SetTextString, 0,0,0,0, $op2, @line$)
      XuiSendMessage(grid, #Redraw, 0,0,0,0, $op2, 0)
    END IF
  END SUB

  SUB AddField
    XuiSendMessage(grid, #GetTextArrayLine, v0, 0,0,0, kid, @line$)
    IF(kid == $xlFields1) THEN
      XuiSendMessage(grid, #SetTextString, 0,0,0,0, $field1, @line$)
      XuiSendMessage(grid, #Redraw, 0,0,0,0, $field1, 0)
    ELSE
      XuiSendMessage(grid, #SetTextString, 0,0,0,0, $field2, @line$)
      XuiSendMessage(grid, #Redraw, 0,0,0,0, $field2, 0)
    END IF
  END SUB

  SUB Evaluate
    exp$ = ""
    XuiSendMessage(grid, #GetTextString, 0,0,0,0, $field1, @line$)
    IF(line$ == "") THEN EXIT SUB
    exp$ = line$
    XuiSendMessage(grid, #GetTextString, 0,0,0,0, $op1, @line$)
    IF(line$ == "") THEN EXIT SUB
    exp$ = exp$ + "\n" + line$
    XuiSendMessage(grid, #GetTextString, 0,0,0,0, $xtlValue1, @line$)
    IF(line$ == "") THEN EXIT SUB
    exp$ = exp$ + "\n" + line$
    XuiSendMessage(grid, #GetTextString, 0,0,0,0, $logic, @line$)
    IF(line$ == "") THEN GOSUB DoEvaluate
    exp$ = exp$ + "\n" + line$
    XuiSendMessage(grid, #GetTextString, 0,0,0,0, $field2, @line$)
    IF(line$ == "") THEN EXIT SUB
    exp$ = exp$ + "\n" + line$
    XuiSendMessage(grid, #GetTextString, 0,0,0,0, $op2, @line$)
    IF(line$ == "") THEN EXIT SUB
    exp$ = exp$ + "\n" + line$
    XuiSendMessage(grid, #GetTextString, 0,0,0,0, $xtlValue2, @line$)
    IF(line$ == "") THEN EXIT SUB
    exp$ = exp$ + "\n" + line$

    GOSUB DoEvaluate
  END SUB

  SUB DoEvaluate
    XstStringToStringArray(exp$, @exp$[])
    EvaluateExpression(@exp$[])
  END SUB

  SUB Clear
    XuiSendMessage(#ExpressionBuilder, #SetTextString, 0,0,0,0, $field1, 0)
    XuiSendMessage(#ExpressionBuilder, #Redraw, 0,0,0,0, $field1, 0)
    XuiSendMessage(#ExpressionBuilder, #SetTextString, 0,0,0,0, $field2, 0)
    XuiSendMessage(#ExpressionBuilder, #Redraw, 0,0,0,0, $field2, 0)
    XuiSendMessage(#ExpressionBuilder, #SetTextString, 0,0,0,0, $op1, 0)
    XuiSendMessage(#ExpressionBuilder, #Redraw, 0,0,0,0, $op1, 0)
    XuiSendMessage(#ExpressionBuilder, #SetTextString, 0,0,0,0, $op2, 0)
    XuiSendMessage(#ExpressionBuilder, #Redraw, 0,0,0,0, $op2, 0)
    XuiSendMessage(#ExpressionBuilder, #SetTextString, 0,0,0,0, $logic, 0)
    XuiSendMessage(#ExpressionBuilder, #Redraw, 0,0,0,0, $logic, 0)
    XuiSendMessage(#ExpressionBuilder, #SetTextString, 0,0,0,0, $xtlValue1, 0)
    XuiSendMessage(#ExpressionBuilder, #RedrawText, 0,0,0,0, $xtlValue1, 0)
    XuiSendMessage(#ExpressionBuilder, #SetTextString, 0,0,0,0, $xtlValue2, 0)
    XuiSendMessage(#ExpressionBuilder, #RedrawText, 0,0,0,0, $xtlValue2, 0)
  END SUB
END FUNCTION

'
'	##################################
'	#####  ExpressionBuilder ()  #####
'	##################################
'
FUNCTION  ExpressionBuilder (grid, message, v0, v1, v2, v3, r0, (r1, r1$, r1[], r1$[]))
	STATIC  designX,  designY,  designWidth,  designHeight
	STATIC  SUBADDR  sub[]
	STATIC  upperMessage
	STATIC  ExpressionBuilder
'
	$ExpressionBuilder  =   0  ' kid   0 grid type = ExpressionBuilder
	$XuiLabel787        =   1  ' kid   1 grid type = XuiLabel
	$xlFields1          =   2  ' kid   2 grid type = XuiList
	$xpdOperator1       =   3  ' kid   3 grid type = XuiPullDown
	$field1             =   4  ' kid   4 grid type = XuiLabel
	$op1                =   5  ' kid   5 grid type = XuiLabel
	$xtlValue1          =   6  ' kid   6 grid type = XuiTextLine
	$xpdLogic           =   7  ' kid   7 grid type = XuiPullDown
	$xlField2           =   8  ' kid   8 grid type = XuiList
	$xpdOperator2       =   9  ' kid   9 grid type = XuiPullDown
	$logic              =  10  ' kid  10 grid type = XuiLabel
	$field2             =  11  ' kid  11 grid type = XuiLabel
	$op2                =  12  ' kid  12 grid type = XuiLabel
	$xtlValue2          =  13  ' kid  13 grid type = XuiTextLine
	$XuiLabel811        =  14  ' kid  14 grid type = XuiLabel
	$xpbOk              =  15  ' kid  15 grid type = XuiPushButton
	$xpbCancel          =  16  ' kid  16 grid type = XuiPushButton
	$xpbClear           =  17  ' kid  17 grid type = XuiPushButton
	$xlArrow1           =  18  ' kid  18 grid type = XuiLabel
	$xlArrow2           =  19  ' kid  19 grid type = XuiLabel
	$xlArrow3           =  20  ' kid  20 grid type = XuiLabel
	$xlArrow4           =  21  ' kid  21 grid type = XuiLabel
	$xlArrow5           =  22  ' kid  22 grid type = XuiLabel
	$UpperKid           =  22  ' kid maximum
'
'
	IFZ sub[] THEN GOSUB Initialize
	IF XuiProcessMessage (grid, message, @v0, @v1, @v2, @v3, @r0, @r1, ExpressionBuilder) THEN RETURN
	IF (message <= upperMessage) THEN GOSUB @sub[message]
	RETURN

  SUB Callback
    message = r1
    callback = message
    IF (message <= upperMessage) THEN GOSUB @sub[message]
  END SUB

  SUB Create
    IF (v0 <= 0) THEN v0 = 0
    IF (v1 <= 0) THEN v1 = 0
    IF (v2 <= 0) THEN v2 = designWidth
    IF (v3 <= 0) THEN v3 = designHeight
    XuiCreateGrid  (@grid, ExpressionBuilder, @v0, @v1, @v2, @v3, r0, r1, &ExpressionBuilder())
    XuiSendMessage ( grid, #SetGridName, 0, 0, 0, 0, 0, @"ExpressionBuilder")
    XuiLabel       (@g, #Create, 0, 0, 372, 264, r0, grid)
    XuiSendMessage ( g, #SetCallback, grid, &ExpressionBuilder(), -1, -1, $XuiLabel787, grid)
    XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"XuiLabel787")
    XuiSendMessage ( g, #SetBorder, $$BorderValley, $$BorderValley, $$BorderNone, 0, 0, 0)
    XuiList        (@g, #Create, 8, 4, 124, 156, r0, grid)
    XuiSendMessage ( g, #SetCallback, grid, &ExpressionBuilder(), -1, -1, $xlFields1, grid)
    XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xlFields1")
    XuiSendMessage ( g, #SetStyle, 1, 0, 0, 0, 0, 0)
    XuiSendMessage ( g, #SetBorder, $$BorderLoLine1, $$BorderLoLine1, $$BorderNone, 0, 0, 0)
    XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 1, @"List")
    XuiSendMessage ( g, #SetColor, $$White, $$Black, $$Black, $$White, 1, 0)
    XuiSendMessage ( g, #SetColorExtra, $$Grey, $$Green, $$Black, $$White, 1, 0)
    XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 2, @"ScrollH")
    XuiSendMessage ( g, #SetStyle, 1, 0, 0, 0, 2, 0)
    XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 3, @"ScrollV")
    XuiSendMessage ( g, #SetStyle, 1, 0, 0, 0, 3, 0)
    XuiList   (@g, #Create, 132, 4, 36, 156, r0, grid)
    XuiSendMessage ( g, #SetCallback, grid, &ExpressionBuilder(), -1, -1, $xpdOperator1, grid)
    XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xpdOperator1")
    XuiSendMessage ( g, #SetBorder, $$BorderLoLine1, $$BorderLoLine1, $$BorderNone, 0, 0, 0)
    DIM text$[4]
    text$[0] = ">="
    text$[1] = ">"
    text$[2] = "="
    text$[3] = "<"
    text$[4] = "<="
    XuiSendMessage ( g, #SetTextArray, 0, 0, 0, 0, 0, @text$[])
    XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 1, @"Area")
    XuiSendMessage ( g, #Destroy, 0,0,0,0, 2, 0)
    XuiSendMessage ( g, #Destroy, 0,0,0,0, 3, 0)
    XuiSendMessage( g, #SetSize, 1,1, 34, 154, 1, 0)
    XuiLabel       (@g, #Create, 8, 160, 124, 24, r0, grid)
    XuiSendMessage ( g, #SetCallback, grid, &ExpressionBuilder(), -1, -1, $field1, grid)
    XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"field1")
    XuiLabel       (@g, #Create, 132, 160, 36, 24, r0, grid)
    XuiSendMessage ( g, #SetCallback, grid, &ExpressionBuilder(), -1, -1, $op1, grid)
    XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"op1")
    XuiTextLine    (@g, #Create, 8, 208, 124, 24, r0, grid)
    XuiSendMessage ( g, #SetCallback, grid, &ExpressionBuilder(), -1, -1, $xtlValue1, grid)
    XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xtlValue1")
    XuiSendMessage ( g, #SetColor, $$White, $$Black, $$Black, $$White, 0, 0)
    XuiSendMessage ( g, #SetBorder, $$BorderLower1, $$BorderLower1, $$BorderNone, 0, 0, 0)
    XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 1, @"XuiArea797")
    XuiSendMessage ( g, #SetColor, $$White, $$Black, $$Black, $$White, 1, 0)
    XuiList    (@g, #Create, 168, 4, 36, 156, r0, grid)
    XuiSendMessage( g, #SetSize, 1,1, 34, 154, 1, 0)
    XuiSendMessage ( g, #SetCallback, grid, &ExpressionBuilder(), -1, -1, $xpdLogic, grid)
    XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xpdLogic")
    XuiSendMessage ( g, #SetBorder, $$BorderLoLine1, $$BorderLoLine1, $$BorderNone, 0, 0, 0)
    DIM text$[2]
    text$[0] = "AND"
    text$[1] = "OR"
    text$[2] = "---"
    XuiSendMessage ( g, #SetTextArray, 0, 0, 0, 0, 0, @text$[])
    XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 1, @"Area")
    XuiSendMessage ( g, #Destroy, 0,0,0,0, 2, 0)
    XuiSendMessage ( g, #Destroy, 0,0,0,0, 3, 0)
    XuiList        (@g, #Create, 204, 4, 124, 156, r0, grid)
    XuiSendMessage ( g, #SetCallback, grid, &ExpressionBuilder(), -1, -1, $xlField2, grid)
    XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xlField2")
    XuiSendMessage ( g, #SetStyle, 1, 0, 0, 0, 0, 0)
    XuiSendMessage ( g, #SetBorder, $$BorderLoLine1, $$BorderLoLine1, $$BorderNone, 0, 0, 0)
    XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 1, @"List")
    XuiSendMessage ( g, #SetColor, $$White, $$Black, $$Black, $$White, 1, 0)
    XuiSendMessage ( g, #SetColorExtra, $$Grey, $$Green, $$Black, $$White, 1, 0)
    XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 2, @"ScrollH")
    XuiSendMessage ( g, #SetStyle, 1, 0, 0, 0, 2, 0)
    XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 3, @"ScrollV")
    XuiSendMessage ( g, #SetStyle, 1, 0, 0, 0, 3, 0)
    XuiList   (@g, #Create, 328, 4, 36, 156, r0, grid)
    XuiSendMessage ( g, #SetCallback, grid, &ExpressionBuilder(), -1, -1, $xpdOperator2, grid)
    XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xpdOperator2")
    XuiSendMessage ( g, #SetBorder, $$BorderLoLine1, $$BorderLoLine1, $$BorderNone, 0, 0, 0)
    DIM text$[4]
    text$[0] = ">="
    text$[1] = ">"
    text$[2] = "="
    text$[3] = "<"
    text$[4] = "<="
    XuiSendMessage ( g, #SetTextArray, 0, 0, 0, 0, 0, @text$[])
    XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 1, @"Area")
    XuiSendMessage ( g, #Destroy, 0,0,0,0, 2, 0)
    XuiSendMessage ( g, #Destroy, 0,0,0,0, 3, 0)
    XuiSendMessage( g, #SetSize, 1,1, 34, 154, 1, 0)
    XuiLabel       (@g, #Create, 168, 160, 36, 24, r0, grid)
    XuiSendMessage ( g, #SetCallback, grid, &ExpressionBuilder(), -1, -1, $logic, grid)
    XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"logic")
    XuiLabel       (@g, #Create, 204, 160, 124, 24, r0, grid)
    XuiSendMessage ( g, #SetCallback, grid, &ExpressionBuilder(), -1, -1, $field2, grid)
    XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"field2")
    XuiLabel       (@g, #Create, 328, 160, 36, 24, r0, grid)
    XuiSendMessage ( g, #SetCallback, grid, &ExpressionBuilder(), -1, -1, $op2, grid)
    XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"op2")
    XuiTextLine    (@g, #Create, 204, 208, 124, 24, r0, grid)
    XuiSendMessage ( g, #SetCallback, grid, &ExpressionBuilder(), -1, -1, $xtlValue2, grid)
    XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xtlValue2")
    XuiSendMessage ( g, #SetColor, $$White, $$Black, $$Black, $$White, 0, 0)
    XuiSendMessage ( g, #SetBorder, $$BorderLower1, $$BorderLower1, $$BorderNone, 0, 0, 0)
    XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 1, @"XuiArea810")
    XuiSendMessage ( g, #SetColor, $$White, $$Black, $$Black, $$White, 1, 0)
    XuiLabel       (@g, #Create, 0, 264, 372, 48, r0, grid)
    XuiSendMessage ( g, #SetCallback, grid, &ExpressionBuilder(), -1, -1, $XuiLabel811, grid)
    XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"XuiLabel811")
    XuiSendMessage ( g, #SetBorder, $$BorderValley, $$BorderValley, $$BorderNone, 0, 0, 0)
    XuiPushButton  (@g, #Create, 60, 276, 80, 20, r0, grid)
    XuiSendMessage ( g, #SetCallback, grid, &ExpressionBuilder(), -1, -1, $xpbOk, grid)
    XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xpbOk")
    XuiSendMessage ( g, #SetTexture, $$TextureNone, 0, 0, 0, 0, 0)
    XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"Ok")
    XuiPushButton  (@g, #Create, 228, 276, 80, 20, r0, grid)
    XuiSendMessage ( g, #SetCallback, grid, &ExpressionBuilder(), -1, -1, $xpbCancel, grid)
    XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xpbCancel")
    XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"Cancel")
    XuiPushButton  (@g, #Create, 144, 276, 80, 20, r0, grid)
    XuiSendMessage ( g, #SetCallback, grid, &ExpressionBuilder(), -1, -1, $xpbClear, grid)
    XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xpbClear")
    XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"Clear")
    XuiLabel       (@g, #Create, 8, 184, 124, 24, r0, grid)
    XuiSendMessage ( g, #SetCallback, grid, &ExpressionBuilder(), -1, -1, $xlArrow1, grid)
    XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xlArrow1")
    XuiSendMessage ( g, #SetBorder, $$BorderNone, $$BorderNone, $$BorderNone, 0, 0, 0)
    XuiSendMessage ( g, #SetImage, 0,0,0,0,0, "C:\\xfile\\images\\a2.bmp")
    XuiLabel       (@g, #Create, 132, 184, 36, 24, r0, grid)
    XuiSendMessage ( g, #SetCallback, grid, &ExpressionBuilder(), -1, -1, $xlArrow2, grid)
    XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xlArrow2")
    XuiSendMessage ( g, #SetBorder, $$BorderNone, $$BorderNone, $$BorderNone, 0, 0, 0)
    XuiSendMessage ( g, #SetImage, 0,0,0,0,0, "C:\\xfile\\images\\a1.bmp")
    XuiLabel       (@g, #Create, 132, 208, 72, 24, r0, grid)
    XuiSendMessage ( g, #SetCallback, grid, &ExpressionBuilder(), -1, -1, $xlArrow3, grid)
    XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xlArrow3")
    XuiSendMessage ( g, #SetBorder, $$BorderNone, $$BorderNone, $$BorderNone, 0, 0, 0)
    XuiSendMessage ( g, #SetImage, 0,0,0,0,0, "C:\\xfile\\images\\a3.bmp")
    XuiLabel       (@g, #Create, 168, 184, 36, 24, r0, grid)
    XuiSendMessage ( g, #SetCallback, grid, &ExpressionBuilder(), -1, -1, $xlArrow4, grid)
    XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xlArrow4")
    XuiSendMessage ( g, #SetBorder, $$BorderNone, $$BorderNone, $$BorderNone, 0, 0, 0)
    XuiSendMessage ( g, #SetTexture, $$TextureNone, 0, 0, 0, 0, 0)
    XuiSendMessage ( g, #SetImage, 0,0,0,0,0, "C:\\xfile\\images\\a4.bmp")
    XuiLabel       (@g, #Create, 328, 184, 36, 48, r0, grid)
    XuiSendMessage ( g, #SetCallback, grid, &ExpressionBuilder(), -1, -1, $xlArrow5, grid)
    XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xlArrow5")
    XuiSendMessage ( g, #SetBorder, $$BorderNone, $$BorderNone, $$BorderNone, 0, 0, 0)
    XuiSendMessage ( g, #SetImage, 0,0,0,0,0, "C:\\xfile\\images\\a5.bmp")
    GOSUB Resize
  END SUB
  '
  '
  ' *****  CreateWindow  *****  v0123 = xywh : r0 = windowType : r1$ = display$
  '
  SUB CreateWindow
    IF (v0 == 0) THEN v0 = designX
    IF (v1 == 0) THEN v1 = designY
    IF (v2 <= 0) THEN v2 = designWidth
    IF (v3 <= 0) THEN v3 = designHeight
    XuiWindow (@window, #WindowCreate, v0, v1, v2, v3, r0, @r1$)
    v0 = 0 : v1 = 0 : r0 = window : ATTACH r1$ TO display$
    GOSUB Create
    r1 = 0 : ATTACH display$ TO r1$
    XuiWindow (window, #WindowRegister, grid, -1, v2, v3, @r0, @"ExpressionBuilder")
  END SUB
  '
  '
  ' *****  GetSmallestSize  *****  see "Anatomy of Grid Functions"
  '
  SUB GetSmallestSize
  END SUB
  '
  '
  ' *****  Redrawn  *****  see "Anatomy of Grid Functions"
  '
  SUB Redrawn
    XuiCallback (grid, #Redrawn, v0, v1, v2, v3, r0, r1)
  END SUB
  '
  '
  ' *****  Resize  *****  see "Anatomy of Grid Functions"
  '
  SUB Resize
  END SUB
  '
  '
  ' *****  Selection  *****  see "Anatomy of Grid Functions"
  '
  SUB Selection
  END SUB
  '
  '
  ' *****  Initialize  *****  see "Anatomy of Grid Functions"
  '
  SUB Initialize
    XuiGetDefaultMessageFuncArray (@func[])
    XgrMessageNameToNumber (@"LastMessage", @upperMessage)
  '
    func[#Callback]           = &XuiCallback ()               ' disable to handle Callback messages internally
  ' func[#GetSmallestSize]    = 0                             ' enable to add internal GetSmallestSize routine
  ' func[#Resize]             = 0                             ' enable to add internal Resize routine
  '
    DIM sub[upperMessage]
  '	sub[#Callback]            = SUBADDRESS (Callback)         ' enable to handle Callback messages internally
    sub[#Create]              = SUBADDRESS (Create)           ' must be subroutine in this function
    sub[#CreateWindow]        = SUBADDRESS (CreateWindow)     ' must be subroutine in this function
  '	sub[#GetSmallestSize]     = SUBADDRESS (GetSmallestSize)  ' enable to add internal GetSmallestSize routine
    sub[#Redrawn]             = SUBADDRESS (Redrawn)          ' generate #Redrawn callback if appropriate
  '	sub[#Resize]              = SUBADDRESS (Resize)           ' enable to add internal Resize routine
    sub[#Selection]           = SUBADDRESS (Selection)        ' routes Selection callbacks to subroutine
  '
    IF sub[0] THEN PRINT "ExpressionBuilder() : Initialize : error ::: (undefined message)"
    IF func[0] THEN PRINT "ExpressionBuilder() : Initialize : error ::: (undefined message)"
    XuiRegisterGridType (@ExpressionBuilder, "ExpressionBuilder", &ExpressionBuilder(), @func[], @sub[])
  '
  ' Don't remove the following 4 lines, or WindowFromFunction/WindowToFunction will not work
  '
    designX = 140
    designY = 361
    designWidth = 372
    designHeight = 312
  '
    gridType = ExpressionBuilder
    XuiSetGridTypeProperty (gridType, @"x",                designX)
    XuiSetGridTypeProperty (gridType, @"y",                designY)
    XuiSetGridTypeProperty (gridType, @"width",            designWidth)
    XuiSetGridTypeProperty (gridType, @"height",           designHeight)
    XuiSetGridTypeProperty (gridType, @"maxWidth",         designWidth)
    XuiSetGridTypeProperty (gridType, @"maxHeight",        designHeight)
    XuiSetGridTypeProperty (gridType, @"minWidth",         designWidth)
    XuiSetGridTypeProperty (gridType, @"minHeight",        designHeight)
    XuiSetGridTypeProperty (gridType, @"can",              $$Focus OR $$Respond OR $$Callback OR $$TextSelection)
    XuiSetGridTypeProperty (gridType, @"focusKid",         $xlFields1)
    XuiSetGridTypeProperty (gridType, @"inputTextString",  $xtlValue1)
    IFZ message THEN RETURN
  END SUB
END FUNCTION

'See if there is a summary field attached to the supplied index
FUNCTION GetSummaryField(index, @field)
  SHARED FIELD FieldList[]
  field = -1

  IF(FieldList[index].type != $$FT_SUMMARY) THEN
    FOR i = 0 TO UBOUND(FieldList[])
      IF(FieldList[i].type == $$FT_SUMMARY) THEN
        IF(FieldList[i].max == index) THEN
          field = i
          RETURN $$TRUE
        END IF
      END IF
    NEXT i
  END IF

  RETURN $$FALSE
END FUNCTION

' ##############################
' #####  GetWeekOfYear ()  #####
' ##############################
'
' Thank you Claus Tondering for this formula
'
FUNCTION  GetWeekOfYear (year, month, day)

  a = (14 - month) / 12
  y = year + 4800 - a
  m = month + (12 * a) - 3

  J = day + (153 * m + 2)/5 + y * 365 + y/4 - y/100 + y/400 - 32045
  d4 = (J + 31741 - (J MOD 7)) MOD 146097 MOD 36524 MOD 1461
  L = d4 / 1460
  d1 = ((d4 - L) MOD 365) + L
  week = (d1 / 7) + 1

  RETURN week
END FUNCTION
'TODO file name like "foo.bar.jpg" comes in
'as "foo.bar .jpg"
FUNCTION ConvertImage(@file$, @converted)
  converted = $$FALSE

  GOSUB CheckFileExtension

  cmd$ = $$IMG_CONVERTER$ + " \"" + file$ + "\" " + "-w --24 --o "
  file$ = LEFT$(file$, pos)
  file$ = "\"" + file$ + "bmp\""

  'See if file already exists
  err = OPEN(file$, $$RD)
  IF(err > 0) THEN
    ShowMessage("Cannot convert file!\n" + file$ + " already exists!")
    Log($$LOG_INFO, file$ + " already exists!")
    CLOSE(err)
    RETURN $$FALSE
  END IF

  cmd$ = cmd$ + file$
  Log($$LOG_INFO, "Converting file to " + file$)
  Log($$LOG_DEBUG, cmd$)
  err = SHELL(cmd$)

  IF(err != 0) THEN
    ShowMessage("Could not convert image file!")
    Log($$LOG_INFO, "Conversion failed. Returned " + STRING$(err))
    RETURN $$FALSE
  END IF

  converted = $$TRUE

  RETURN $$TRUE

  SUB CheckFileExtension
	  pos = 1
	  DO
      err = INSTR(file$, ".", pos)
			IF(err > 0) THEN
			  pos = err + 1
		  ELSE
				EXIT DO
			END IF
	  LOOP
    IF(pos == 0) THEN
		  ShowMessage("Unsupported image format!")
      RETURN $$FALSE
	  END IF

		pos = pos - 1

    ext$ = RIGHT$(file$, LEN(file$) - pos)
    Log($$LOG_DEBUG, "File extension: " + ext$)
    ext$ = UCASE$(ext$)
    SELECT CASE ext$
      CASE "BMP"  : RETURN $$TRUE
      CASE "JPG"  : EXIT SUB
      CASE "JPEG" : EXIT SUB
      CASE "PNG"  : EXIT SUB
      CASE "GIF"  : EXIT SUB
      CASE "TIF"  : EXIT SUB
      CASE "PCX"  : EXIT SUB
      CASE ELSE   :
        ShowMessage("Unsupported image format!")
        RETURN $$FALSE
    END SELECT
  END SUB

END FUNCTION

FUNCTION InsertDate()
  XuiSendMessage(#GeoFile, #GetKeyboardFocusGrid, @grid, 0,0,0,0,0)
  IF(GetFieldByGrid(grid, @index)) THEN
    XstGetLocalDateAndTime(@v0, @v1, @v2, 0, 0, 0, 0, 0)
    date$ = STRING$(v1) + "/" + STRING$(v2) + "/" + STRING$(v0)
    XuiSendMessage(grid, #GetTextString, 0,0,0,0,0, @file$)
    IF(file$) THEN
      file$ = file$ + " " + date$
    ELSE
      file$ = date$
    END IF
    XuiSendMessage(grid, #SetTextString, 0,0,0,0,0, @file$)
    XuiSendMessage(grid, #RedrawText,0,0,0,0,0,0)
  END IF
END FUNCTION

'Get the next field relative to the current
'selected object in either the up or down direction
'This is a cluster-fuck of a function and shows
'that I made a big design mistake in keeping two
'separate lists FieldList and LabelList.  Should
'have always just had everything in one list.
'
'Returns the index into ObjectList[] of the
'next object!
FUNCTION GetNextField(in, @out, dir, labels)
  SHARED FIELD FieldList[]
	SHARED FIELD LabelList[]
	SHARED FIELD ObjectList[]
  FIELD null[]

  ' Combine FieldList and LabelList into ObjectList[]
	' if we want to include LabelList objects in the search
	IF(labels) THEN
		CombineFieldLists(@FieldList[], @LabelList[], @ObjectList[])
		'recalculate index of selected Label
    IF(GetLabelByGrid(#SelectedGrid, @index)) THEN
			in = in + UBOUND(FieldList[]) + 1
    END IF
	ELSE
		REDIM null[]
		CombineFieldLists(@FieldList[], @null[], @ObjectList[])
  END IF
  out = -1

  SELECT CASE dir
    CASE $$DOWN : GOSUB Down
    CASE $$UP   : GOSUB Up
  END SELECT

  SUB Up
    x = -1
    y = -1
    deltay = 9999999
    'First, see if there is a field on my left with same y value
    'If so, find right-most field that is on my left
    FOR i = 0 TO UBOUND(ObjectList[])
			IF(labels == $$FALSE && ObjectList[i].grid_type != $$ENTRY) THEN
			  DO NEXT
		  END IF
      IF(i != in) THEN
        IF(ObjectList[i].in_layout && ObjectList[i].y == ObjectList[in].y) THEN
          IF(ObjectList[i].x < ObjectList[in].x && ObjectList[i].x > x) THEN
            out = i
            x = ObjectList[i].x
          END IF
        END IF
      END IF
    NEXT i
    IF(out != -1) THEN GOSUB Finish

    'If first part fails to find a field,
    'Try to find next highest, rightmost field
    FOR i = 0 TO UBOUND(ObjectList[])
			IF(labels == $$FALSE && ObjectList[i].grid_type != $$ENTRY) THEN
			  DO NEXT
		  END IF
      IF(i != in) THEN
        IF(ObjectList[i].in_layout && ObjectList[i].y < ObjectList[in].y) THEN
          dy = ObjectList[in].y - ObjectList[i].y
          SELECT CASE TRUE
            CASE dy == deltay:
              IF(ObjectList[i].x >= x) THEN
                x = ObjectList[i].x
                out = i
              END IF
            CASE dy < deltay:
              out = i
              x = ObjectList[i].x
							deltay = dy
          END SELECT
        END IF
      END IF
    NEXT i

    GOSUB Finish
  END SUB

  SUB Down
    x = 999999
    y = 999999
    deltay = 9999999
    'First, see if there is a field on my right with same y value
    'If so, find left-most field that is on my right
    FOR i = 0 TO UBOUND(ObjectList[])
			IF(labels == $$FALSE && ObjectList[i].grid_type != $$ENTRY) THEN
			  DO NEXT
		  END IF
      IF(i != in) THEN
        IF(ObjectList[i].in_layout && ObjectList[i].y == ObjectList[in].y) THEN
          IF(ObjectList[i].x > ObjectList[in].x && ObjectList[i].x < x) THEN
            out = i
            x = ObjectList[i].x
          END IF
        END IF
      END IF
    NEXT i
    IF(out != -1) THEN GOSUB Finish

    'If first part fails to find a field,
    'Try to find next lowest, leftmost field
    FOR i = 0 TO UBOUND(ObjectList[])
			IF(labels == $$FALSE && ObjectList[i].grid_type != $$ENTRY) THEN
			  DO NEXT
		  END IF
      IF(i != in) THEN
        IF(ObjectList[i].in_layout && ObjectList[i].y > ObjectList[in].y) THEN
          dy = ObjectList[i].y - ObjectList[in].y
          SELECT CASE TRUE
            CASE dy == deltay:
              IF(ObjectList[i].x <= x) THEN
                x = ObjectList[i].x
                out = i
              END IF
            CASE dy < deltay:
              out = i
              x = ObjectList[i].x
							deltay = dy
          END SELECT
        END IF
      END IF
    NEXT i

    GOSUB Finish
  END SUB

  SUB Finish
		'Wrap
    IF(out == -1) THEN
      SELECT CASE dir
        CASE $$DOWN : GOSUB GetUpperLeft
        CASE $$UP   : GOSUB GetLowerRight
      END SELECT
    END IF

    RETURN
  END SUB

  SUB GetUpperLeft
    x = 9999999
    y = 9999999
    FOR i = 0 TO UBOUND(ObjectList[])
			IF(labels == $$FALSE && ObjectList[i].grid_type != $$ENTRY) THEN
			  DO NEXT
		  END IF
      IF(ObjectList[i].in_layout) THEN
        SELECT CASE TRUE
          CASE ObjectList[i].y == y :
            IF(ObjectList[i].x < x) THEN
              out = i
              x = ObjectList[i].x
            END IF
          CASE ObjectList[i].y < y :
            x = ObjectList[i].x
            y = ObjectList[i].y
            out = i
        END SELECT
      END IF
    NEXT i
  END SUB

  SUB GetLowerRight
    x = -1
    y = -1
    FOR i = 0 TO UBOUND(ObjectList[])
			IF(labels == $$FALSE && ObjectList[i].grid_type != $$ENTRY) THEN
			  DO NEXT
		  END IF
      IF(ObjectList[i].in_layout) THEN
        SELECT CASE TRUE
          CASE ObjectList[i].y == y :
            IF(ObjectList[i].x > x) THEN
              out = i
              x = ObjectList[i].x
            END IF
          CASE ObjectList[i].y > y :
            x = ObjectList[i].x
            y = ObjectList[i].y
            out = i
        END SELECT
      END IF
    NEXT i
  END SUB
END FUNCTION

'Read xfile.cfg
'Allows blank lines
'Allows # as comment line
'Allows spaces
'
FUNCTION ReadConfigFile(file$)
  REDIM #Buff$[]

  'Test for existence of config file
  err = OPEN(file$, $$RD)
  IF(err < 0) THEN
    GOSUB GenerateConfigFile
  ELSE
    CLOSE(err)
  END IF

  err = XstLoadStringArray(@file$, @#Buff$[])
  IF(err != 0) THEN
    Log($$LOG_ERROR, "Error reading configuration file!")
    ShowMessage("Error reading configuration file!")
    RETURN $$FALSE
  END IF
  FOR i = 0 TO UBOUND(#Buff$[])
    line$ = #Buff$[i]
    IF(line$ == "" || LEFT$(line$, 1) == "#") THEN DO NEXT
    Tokenize(line$, @out$[], "=")
    IF(UBOUND(out$[]) != 1) THEN
      Log($$LOG_ERROR, "Error on line " + STRING$(i + 1) + " of configuration file")
      DO NEXT
    END IF
    out$[0] = TRIM$(out$[0])
    out$[1] = TRIM$(out$[1])
    SELECT CASE out$[0]
      CASE "SlideShowDelay" : #SlideShowDelay = 1000 * XLONG(out$[1])
      CASE "BitmapEditor"   : #BitmapEditor$ = out$[1]
      CASE "NoScrollbars"   : IF(out$[1] == "1") THEN #NoScrollbars = $$TRUE ELSE #NoScrollbars = $$FALSE
      CASE "Debug"          : IF(out$[1] == "1") THEN #DEBUG = $$TRUE ELSE #DEBUG = $$FALSE
      CASE "ShowConsole"    : IF(out$[1] == "1") THEN #ShowConsole = $$TRUE ELSE #ShowConsole = $$FALSE
      CASE "HTMLViewer"     : #HTMLViewer$ = out$[1]
    END SELECT
  NEXT i

  RETURN $$TRUE

  SUB GenerateConfigFile
    Log($$LOG_INFO, "Auto-generating " + #ConfigFile$)
    i = -1
    INC i : REDIM #Buff$[i] : #Buff$[i] = "#XFile global configuration file"
    INC i : REDIM #Buff$[i] : #Buff$[i] = "#Format: parameter = value"
    INC i : REDIM #Buff$[i] : #Buff$[i] = "# 1 = TRUE, 0 = FALSE"
    INC i : REDIM #Buff$[i] : #Buff$[i] = "#"
    INC i : REDIM #Buff$[i] : #Buff$[i] = "#Time in seconds for each record to display"
    INC i : REDIM #Buff$[i] : #Buff$[i] = "SlideShowDelay = " + STRING$(#SlideShowDelay)
    INC i : REDIM #Buff$[i] : #Buff$[i] = "#Bitmap editor"
    INC i : REDIM #Buff$[i] : #Buff$[i] = "BitmapEditor = C:\\WINDOWS\\System32\\mspaint.exe"
    INC i : REDIM #Buff$[i] : #Buff$[i] = "#HTML viewer"
    INC i : REDIM #Buff$[i] : #Buff$[i] = "HTMLViewer = C:\\Program Files\\Internet Explorer\\iexplore.exe"
    INC i : REDIM #Buff$[i] : #Buff$[i] = "#Show/hide scrollbars on multi-line text fields"
    INC i : REDIM #Buff$[i] : #Buff$[i] = "NoScrollbars = 1"
    INC i : REDIM #Buff$[i] : #Buff$[i] = "#Show/hide logging console on startup"
    INC i : REDIM #Buff$[i] : #Buff$[i] = "ShowConsole = 1"
    INC i : REDIM #Buff$[i] : #Buff$[i] = "#Enable debugging output in console"
    INC i : REDIM #Buff$[i] : #Buff$[i] = "Debug = 0"
    err = XstSaveStringArray(file$, @#Buff$[])
    IF(err) THEN
      Log($$LOG_ERROR, "Could not auto-generate " + #ConfigFile$ + "!")
      ShowMessage("Could not auto-generate " + #ConfigFile$ + "!")
      RETURN
    END IF
  END SUB
END FUNCTION

'	##############################
'	#####  Configuration ()  #####
'	##############################
'
FUNCTION  Configuration (grid, message, v0, v1, v2, v3, r0, (r1, r1$, r1[], r1$[]))
	STATIC  designX,  designY,  designWidth,  designHeight
	STATIC  SUBADDR  sub[]
	STATIC  upperMessage
	STATIC  Configuration
'
	$Configuration    =   0  ' kid   0 grid type = Configuration
	$XuiLabel754      =   1  ' kid   1 grid type = XuiLabel
	$XuiLabel755      =   2  ' kid   2 grid type = XuiLabel
	$xtaConfigEditor  =   3  ' kid   3 grid type = XuiTextArea
	$xpbApply         =   4  ' kid   4 grid type = XuiPushButton
	$xpbClose         =   5  ' kid   5 grid type = XuiPushButton
	$UpperKid         =   5  ' kid maximum
'
'
	IFZ sub[] THEN GOSUB Initialize
	IF XuiProcessMessage (grid, message, @v0, @v1, @v2, @v3, @r0, @r1, Configuration) THEN RETURN
	IF (message <= upperMessage) THEN GOSUB @sub[message]
	RETURN
  '
  '
  ' *****  Callback  *****  message = Callback : r1 = original message
  '
  SUB Callback
    message = r1
    callback = message
    IF (message <= upperMessage) THEN GOSUB @sub[message]
  END SUB
  '
  '
  ' *****  Create  *****  v0123 = xywh : r0 = window : r1 = parent
  '
  SUB Create
    IF (v0 <= 0) THEN v0 = 0
    IF (v1 <= 0) THEN v1 = 0
    IF (v2 <= 0) THEN v2 = designWidth
    IF (v3 <= 0) THEN v3 = designHeight
    XuiCreateGrid  (@grid, Configuration, @v0, @v1, @v2, @v3, r0, r1, &Configuration())
    XuiSendMessage ( grid, #SetGridName, 0, 0, 0, 0, 0, @"Configuration")
    XuiLabel       (@g, #Create, 0, 0, 312, 308, r0, grid)
    XuiSendMessage ( g, #SetCallback, grid, &Configuration(), -1, -1, $XuiLabel754, grid)
    XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"XuiLabel754")
    XuiSendMessage ( g, #SetBorder, $$BorderValley, $$BorderValley, $$BorderNone, 0, 0, 0)
    XuiLabel       (@g, #Create, 0, 308, 312, 44, r0, grid)
    XuiSendMessage ( g, #SetCallback, grid, &Configuration(), -1, -1, $XuiLabel755, grid)
    XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"XuiLabel755")
    XuiSendMessage ( g, #SetBorder, $$BorderValley, $$BorderValley, $$BorderNone, 0, 0, 0)
    XuiTextArea    (@g, #Create, 4, 4, 304, 300, r0, grid)
    XuiSendMessage ( g, #SetCallback, grid, &Configuration(), -1, -1, $xtaConfigEditor, grid)
    XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xtaConfigEditor")
    XuiSendMessage ( g, #SetStyle, 1, 0, 0, 0, 0, 0)
    XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 1, @"Text")
    XuiSendMessage ( g, #SetColor, $$White, $$Black, $$Black, $$White, 1, 0)
    XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 2, @"ScrollH")
    XuiSendMessage ( g, #SetStyle, 1, 0, 0, 0, 2, 0)
    XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 3, @"ScrollV")
    XuiSendMessage ( g, #SetStyle, 1, 0, 0, 0, 3, 0)
    XuiPushButton  (@g, #Create, 36, 320, 80, 20, r0, grid)
    XuiSendMessage ( g, #SetCallback, grid, &Configuration(), -1, -1, $xpbApply, grid)
    XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xpbApply")
    XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"Apply")
    XuiPushButton  (@g, #Create, 180, 320, 80, 20, r0, grid)
    XuiSendMessage ( g, #SetCallback, grid, &Configuration(), -1, -1, $xpbClose, grid)
    XuiSendMessage ( g, #SetGridName, 0, 0, 0, 0, 0, @"xpbClose")
    XuiSendMessage ( g, #SetTextString, 0, 0, 0, 0, 0, @"Close")
    GOSUB Resize
  END SUB
  '
  '
  ' *****  CreateWindow  *****  v0123 = xywh : r0 = windowType : r1$ = display$
  '
  SUB CreateWindow
    IF (v0 == 0) THEN v0 = designX
    IF (v1 == 0) THEN v1 = designY
    IF (v2 <= 0) THEN v2 = designWidth
    IF (v3 <= 0) THEN v3 = designHeight
    XuiWindow (@window, #WindowCreate, v0, v1, v2, v3, r0, @r1$)
    v0 = 0 : v1 = 0 : r0 = window : ATTACH r1$ TO display$
    GOSUB Create
    r1 = 0 : ATTACH display$ TO r1$
    XuiWindow (window, #WindowRegister, grid, -1, v2, v3, @r0, @"Configuration")
  END SUB
  '
  '
  ' *****  GetSmallestSize  *****  see "Anatomy of Grid Functions"
  '
  SUB GetSmallestSize
  END SUB
  '
  '
  ' *****  Redrawn  *****  see "Anatomy of Grid Functions"
  '
  SUB Redrawn
    XuiCallback (grid, #Redrawn, v0, v1, v2, v3, r0, r1)
  END SUB
  '
  '
  ' *****  Resize  *****  see "Anatomy of Grid Functions"
  '
  SUB Resize
  END SUB
  '
  '
  ' *****  Selection  *****  see "Anatomy of Grid Functions"
  '
  SUB Selection
  END SUB
  '
  '
  ' *****  Initialize  *****  see "Anatomy of Grid Functions"
  '
  SUB Initialize
    XuiGetDefaultMessageFuncArray (@func[])
    XgrMessageNameToNumber (@"LastMessage", @upperMessage)
  '
    func[#Callback]           = &XuiCallback ()               ' disable to handle Callback messages internally
  ' func[#GetSmallestSize]    = 0                             ' enable to add internal GetSmallestSize routine
    func[#Resize]             = &XuiResizeWindowToGrid()                  ' enable to add internal Resize routine
  '
    DIM sub[upperMessage]
  '	sub[#Callback]            = SUBADDRESS (Callback)         ' enable to handle Callback messages internally
    sub[#Create]              = SUBADDRESS (Create)           ' must be subroutine in this function
    sub[#CreateWindow]        = SUBADDRESS (CreateWindow)     ' must be subroutine in this function
  '	sub[#GetSmallestSize]     = SUBADDRESS (GetSmallestSize)  ' enable to add internal GetSmallestSize routine
    sub[#Redrawn]             = SUBADDRESS (Redrawn)          ' generate #Redrawn callback if appropriate
  '	sub[#Resize]              = SUBADDRESS (Resize)           ' enable to add internal Resize routine
    sub[#Selection]           = SUBADDRESS (Selection)        ' routes Selection callbacks to subroutine
  '
    IF sub[0] THEN PRINT "Configuration() : Initialize : error ::: (undefined message)"
    IF func[0] THEN PRINT "Configuration() : Initialize : error ::: (undefined message)"
    XuiRegisterGridType (@Configuration, "Configuration", &Configuration(), @func[], @sub[])
  '
  ' Don't remove the following 4 lines, or WindowFromFunction/WindowToFunction will not work
  '
    designX = 457
    designY = 74
    designWidth = 312
    designHeight = 352
  '
    gridType = Configuration
    XuiSetGridTypeProperty (gridType, @"x",                designX)
    XuiSetGridTypeProperty (gridType, @"y",                designY)
    XuiSetGridTypeProperty (gridType, @"width",            designWidth)
    XuiSetGridTypeProperty (gridType, @"height",           designHeight)
    XuiSetGridTypeProperty (gridType, @"maxWidth",         designWidth)
    XuiSetGridTypeProperty (gridType, @"maxHeight",        designHeight)
    XuiSetGridTypeProperty (gridType, @"minWidth",         designWidth)
    XuiSetGridTypeProperty (gridType, @"minHeight",        designHeight)
    XuiSetGridTypeProperty (gridType, @"can",              $$Focus OR $$Respond OR $$Callback OR $$InputTextString)
    XuiSetGridTypeProperty (gridType, @"focusKid",         $xtaConfigEditor)
    XuiSetGridTypeProperty (gridType, @"inputTextArray",   $xtaConfigEditor)
    IFZ message THEN RETURN
  END SUB

'This is the end. My lonely friend... the end.
END FUNCTION

'
'
' ##################################
' #####  ConfigurationCode ()  #####
' ##################################
'
'
FUNCTION  ConfigurationCode (grid, message, v0, v1, v2, v3, kid, r1)
	$Configuration    =   0  ' kid   0 grid type = Configuration
	$XuiLabel754      =   1  ' kid   1 grid type = XuiLabel
	$XuiLabel755      =   2  ' kid   2 grid type = XuiLabel
	$xtaConfigEditor  =   3  ' kid   3 grid type = XuiTextArea
	$xpbApply         =   4  ' kid   4 grid type = XuiPushButton
	$xpbClose         =   5  ' kid   5 grid type = XuiPushButton
	$UpperKid         =   5  ' kid maximum

	IF (message == #Callback) THEN message = r1
'
	SELECT CASE message
    CASE #Notify      : GOSUB Update
		CASE #Selection		: GOSUB Selection   	' most common callback message
		CASE #CloseWindow	: XuiSendMessage (grid, #HideWindow, 0, 0, 0, 0, 0, 0)
	END SELECT
	RETURN

  SUB Update
    REDIM #Buff$[]
    err = XstLoadStringArray(#ConfigFile$, @#Buff$[])
    IF(err) THEN
      ShowMessage("Could not read " + #ConfigFile$)
      RETURN
    END IF
    XuiSendMessage(#Configuration, #SetTextArray, 0,0,0,0, $xtaConfigEditor, @#Buff$[])
    XuiSendMessage(#Configuration, #Redraw, 0,0,0,0, $xtaConfigEditor, 0)
  END SUB

  SUB Selection
    SELECT CASE kid
      CASE $Configuration    :
      CASE $XuiLabel754      :
      CASE $XuiLabel755      :
      CASE $xtaConfigEditor  :
      CASE $xpbApply         : GOSUB ApplyChanges
      CASE $xpbClose         : XuiSendMessage(#Configuration, #HideWindow, 0,0,0,0,0,0)
    END SELECT
  END SUB

  SUB ApplyChanges
    Log($$LOG_INFO, "Applying changes...")
    XuiSendMessage(#Configuration, #GetTextArray, 0,0,0,0, $xtaConfigEditor, @#Buff$[])
    XstSaveStringArray(#ConfigFile$, @#Buff$[])
    ReadConfigFile(#ConfigFile$)
  END SUB
END FUNCTION

'Combine the lists a and b into list
FUNCTION CombineFieldLists(FIELD a[], FIELD b[], FIELD list[])
  c = ((UBOUND(a[]) + 1) + (UBOUND(b[]) + 1) - 1)
	REDIM list[c]
	z = 0
	FOR i = 0 TO UBOUND(a[])
		list[z] = a[i]
		INC z
  NEXT i
	FOR i = 0 TO UBOUND(b[])
		list[z] = b[i]
		INC z
  NEXT i
END FUNCTION

FUNCTION UpdateShowMarked(record)
  SHARED MODE Mode

  IF(record != -1) THEN
    Mode.viewMode = $$VIEW_MARKED
    DisplayRecord(record, $$TRUE)
  ELSE
    ShowMessage("No Marked Records!")
    Mode.viewMode = $$VIEW_ALL
    #ShowOnlyMarked = $$FALSE
  END IF
END FUNCTION

FUNCTION Help ()
  XuiMessage("Help not implemented")
END FUNCTION

FUNCTION ExportHTML (file$, mode)
  SHARED RecordOrder[]
  SHARED RecordList[]
  SHARED FIELD FieldList[]
  SHARED StringData$[]

  count = 0
  str$ = "<html><head><body>"
  str$ = str$ + "<table width='100%' style='background-color:white;border-width:1px;border-color: gray' border='1' cellpadding='2' cellspacing='0'>"
  GetFieldNames(@names$[])
  str$ = str$ + "<tr>"
  FOR i = 0 TO UBOUND(names$[])
    str$ = str$ + "<th>" + names$[i] + "</th>"
  NEXT i
  str$ = str$ + "</tr>"

  FOR i = 0 TO UBOUND(RecordOrder[])
    record = RecordOrder[i]
    first = RecordList[record].first
    last = RecordList[record].last
    SELECT CASE mode
      CASE $$EXPORT_ALL:
        GOSUB ExportAsHTML
      CASE $$EXPORT_MARKED:
        IF(RecordList[record].marked) THEN
          GOSUB ExportAsHTML
        END IF
    END SELECT
    INC count
  NEXT i

  str$ = str$ + "</body></head></html>\n"
  XstSaveString(file$, @str$)
  RETURN count

  SUB ExportAsHTML
    x = 0
    data$ = ""
    str$ = str$ + "<tr>"
    FOR z = first TO last
      IF(StringData$[z] == "") THEN
        data$ = "&nbsp"
      ELSE
        data$ = StringData$[z]
      END IF
      IF(FieldList[x].grid_type = $$IMAGE) THEN
        str$ = str$ + "<td><img src='" + #CurrentProject$ + "\\" +$$STATIC_IMAGE_DIR$ + "\\" + data$ + "'></td>"
      ELSE
        str$ = str$ + "<td>" + data$ + "</td>"
      END IF
      INC x
    NEXT z
    str$ = str$ + "</tr>"
  END SUB

END FUNCTION

FUNCTION RunExternalTool(tool$)
  SHARED FIELD LabelList[]

  SELECT CASE TRUE
    CASE tool$ == #BitmapEditor$ : GOSUB RunBitmapEditor
    CASE tool$ == #HTMLViewer$   : GOSUB RunHTMLViewer
    CASE ELSE                    : ShowMessage("External tool not\ndefined in config file!")
  END SELECT

  SUB RunBitmapEditor
    file$ = ""
    IF(GetLabelByGrid(#SelectedGrid, @index)) THEN
      IF(LabelList[index].grid_type == $$STATIC_IMAGE) THEN
        XuiSendMessage ( #SelectedGrid, #GetImage, 0,0,0,0,0, @file$)
      END IF
    END IF
    SHELL(":\"" + #BitmapEditor$ + "\" " + file$)
  END SUB

  SUB RunHTMLViewer
    file$ = "C:/TEMP/xfile.htm"
    count = ExportHTML(file$, $$EXPORT_ALL)
    cmd$ = ":\"" + #HTMLViewer$ + "\" " + file$
    SHELL(cmd$)
  END SUB

END FUNCTION
END PROGRAM
