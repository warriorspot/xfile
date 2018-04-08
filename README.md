XFile - a data management and layout tool

1. This is very preliminary README

2. The working/project directory is hard-coded as C:\xfile.  To work
properly, run xfile.exe from C:\xfile

4. Things that are there but not implemented:
  - Field notes
  - Default Values

XFile is based on ideas found in GeoFile for PC-GEOS, and FileMaker Pro 2.0
for Windows 3.1.  This document is a very brief overview of features.

- Multiple data layouts
- Image data type
- Static images and labels
- Background image
- Summary data type (Sum, Average, Max, or Min of an Integer or Real field)
- Sorting
- Marking (filtering) records by formula
- Tearoff menus (This is pretty cool, actually)

** Creating a Project ***

1. Launch XFile
2. Chose Create Project
3. Enter a project name (probably a single word)
4. Click the Design Mode button in lower left corner
5. Click Create Fields
6. Add fields of various types.
7. Switch to Data Entry mode
8. Enter data
9. Create more layouts if you want

*** Field Types ***

String (single and multi-line). Maximum of 512 characters (this is actually arbitrary, it could be anything).
Integer : Min/Max is minimum and maximum allowed value
Real    : Min/Max is minimum and maximum allowed value*
Date    : Min/Max has no effect
Summary : Select summary type, then select summary field
Image   : Min/Max are fixed width and height
      (if supplied) otherwise the field resizes to hold the supplied bitmap

Fields may be freely placed anywhere within the "canvas", but should not overlap.
I have not seen any problems with overlapping fields, but XBasic recommends against it.
It is possible (though difficult) to move a field or label outside the bounds of the canvas,
and be irretrievable.  This is a known issue.

The Image field type:
- When in Data Entry mode, left click on the image field
- In the supplied file navigation dialog, select an image file 
- Supported image formats: BMP, JPG, PNG, GIF, TIF, PCX (uses file extension to determine format)
- The selected image will be converted to a 24-bit bitmap if needed.
- The selected bitmap will be copied to the /images directory of your project.
- If the image was converted to a bitmap, the .bmp is moved to your images directory.
- The image name will be stored in the database for that record.
- The image name cannot exceed 32 characters.

Selection Mode:
- Click the little selection button on the left
- Group selection with click and drag
- Single selection with left mouse
- Add another selection with Ctrl-Left Mouse
- (shift) Tab key and middle mouse button cycles through single-selection

Resize:
- Fields can be resized.
- Select a field (objects like labels and static images are not resizable)
- Use Ctrl + arrow keys to resize.  Hold down shift to resize by 5 pixels.

Move:
- Use the mouse to select and move fields
- Also, use arrow keys to move selected fields
- Make use of the Arrange tools under Layout menu in Design mode

Sample Databases
-comics
-todo_list
-photos