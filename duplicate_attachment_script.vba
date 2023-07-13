Public Sub SaveAttachments()
Dim objOL As Outlook.Application
Dim objMsg As Outlook.MailItem 'Object
Dim objAttachments As Outlook.Attachments
Dim objSelection As Outlook.Selection
Dim i As Long
Dim lngCount As Long
Dim strFile As String
Dim strFolderpath As String
Dim strDeletedFiles As String
Dim strExt As String
Dim strUniqueName As String

    ' Get the path to your My Documents folder
    strFolderpath = "C:\Users\[username]\Documents\"
    On Error Resume Next

    ' Instantiate an Outlook Application object.
    Set objOL = CreateObject("Outlook.Application")

    ' Get the collection of selected objects.
    Set objSelection = objOL.ActiveExplorer.Selection

' The attachment folder needs to exist
' You can change this to another folder name of your choice

    ' Set the Attachment folder.
    ' strFolderpath = strFolderpath & "\OLAttachments\"

    ' Check each selected item for attachments.
    For Each objMsg In objSelection

    Set objAttachments = objMsg.Attachments
    lngCount = objAttachments.Count

    If lngCount > 0 Then

    ' Use a count down loop for removing items
    ' from a collection. Otherwise, the loop counter gets
    ' confused and only every other item is removed.

    For i = lngCount To 1 Step -1

    ' Get the file name.
    strFile = objAttachments.Item(i).FileName
        
    ' Can be edited to do multiple formats (need addtional regex)
    strExt = "pdf"
    
    strFile = FileNameUnique(strFolderpath, strFile, strExt)

    ' Save the attachment as a file.
    objAttachments.Item(i).SaveAsFile strFolderpath & strFile

    Next i
    End If

    Next

ExitSub:

Set objAttachments = Nothing
Set objMsg = Nothing
Set objSelection = Nothing
Set objOL = Nothing
End Sub

Private Function FileNameUnique(strPath As String, _
                                strFileName As String, _
                                strExtension As String) As String
Dim lngF As Long
Dim lngName As Long
    lngF = 1
    lngName = Len(strFileName) - (Len(strExtension) + 1)
    strFileName = Left(strFileName, lngName)
    Do While FileExists(strPath & strFileName & Chr(46) & strExtension) = True
        strFileName = Left(strFileName, lngName) & "(" & lngF & ")"
        lngF = lngF + 1
    Loop
    FileNameUnique = strFileName & Chr(46) & strExtension
lbl_Exit:
    Exit Function
End Function

Private Function FileExists(filespec) As Boolean
Dim fso As Object
    Set fso = CreateObject("Scripting.FileSystemObject")
    If fso.FileExists(filespec) Then
        FileExists = True
    Else
        FileExists = False
    End If
lbl_Exit:
    Exit Function
End Function
