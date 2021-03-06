VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "ThisWorkbook"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
Sub stock_market_analyzer()

' Assign variables
Dim ticker As String
Dim year_open As Double
Dim year_close As Double
Dim year_change As Double
Dim percent_change As Double
Dim volume As Double
Dim last_row As Long
Dim row_counter As Double
Dim results_counter As Double

' Iterate through each worksheet

For Each ws In ActiveWorkbook.Worksheets

    ' Label the desired fields
    ws.Cells(1, 9).Value = "Ticker"
    ws.Cells(1, 10).Value = "Yearly Change"
    ws.Cells(1, 11).Value = "Percent Change"
    ws.Cells(1, 12).Value = "Total Stock volume"

    ' Values start at row 2
    results_counter = 2

    ' Find the last row
    last_row = ws.Cells(Rows.Count, 1).End(xlUp).Row

    ' ws.Cells(2, 13).Value = last_row
    volume = 0

    'Find the opening value
    year_open = ws.Cells(2, 3).Value

    ' We iterate from row 2 to the last row
    For row_counter = 2 To last_row

        volume = volume + ws.Cells(row_counter, 7).Value

        ' We compare the current ticker to the one above
        If (ws.Cells(row_counter - 1, 1).Value = ws.Cells(row_counter, 1).Value And ws.Cells(row_counter + 1, 1).Value <> ws.Cells(row_counter, 1).Value) Then

            ' If the current ticker is the same as above and different than the one below
            year_close = ws.Cells(row_counter, 6).Value

            ' Calculate the change between opening and closing values
            year_change = year_close - year_open

            ' Account for divisions by 0
            If year_open = 0 And year_close <> 0 Then
                percent_change = year_close / year_close
            
            ElseIf year_open = 0 And year_close = 0 Then
                percent_change = 0
            
            Else
                percent_change = (year_close - year_open) / year_open
            
            End If

        ' We move to the next year open
        year_open = ws.Cells(row_counter + 1, 3).Value

        ' Show the year change for each ticker
        ws.Cells(results_counter, 10).Value = year_change

        'Conditional formattting for change: if > 0, green; if < 0, red
        If ws.Cells(results_counter, 10).Value > 0 Then
            ws.Cells(results_counter, 10).Interior.ColorIndex = 4
        
        Else
            ws.Cells(results_counter, 10).Interior.ColorIndex = 3

        End If

        ' Show the percent change for each ticker
        ws.Cells(results_counter, 11).Value = percent_change
        ws.Cells(results_counter, 11).NumberFormat = "0.00%"

    End If

    ' Show the total volume for each ticker
    ' If the current ticker is the same as above and different than the one below
    If (ws.Cells(row_counter + 1, 1).Value <> ws.Cells(row_counter, 1).Value) Then

        ' Show ticker
        ws.Cells(results_counter, 9).Value = ws.Cells(row_counter, 1).Value

        ' Show total volume
        ws.Cells(results_counter, 12).Value = volume

        ' Reset the value to 0
        volume = 0

        ' Increase the results counter by 1 for the next loop
        results_counter = results_counter + 1

    End If

Next row_counter

Next ws

End Sub

