VERSION 5.00
Begin VB.Form Form1 
   Caption         =   "1caption1"
   ClientHeight    =   7185
   ClientLeft      =   3270
   ClientTop       =   3960
   ClientWidth     =   8460
   LinkTopic       =   "Form1"
   ScaleHeight     =   7185
   ScaleWidth      =   8460
   Begin VB.CommandButton Command1 
      Caption         =   "Command1"
      Height          =   510
      Left            =   2700
      TabIndex        =   2
      Top             =   3420
      Width           =   1185
   End
   Begin VB.TextBox Text1 
      Height          =   825
      Left            =   1260
      TabIndex        =   0
      Text            =   "Text1"
      Top             =   1800
      Width           =   1995
   End
   Begin VB.Label Label1 
      Caption         =   "Label1"
      Height          =   420
      Left            =   1260
      TabIndex        =   1
      Top             =   1215
      Width           =   1500
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub Command1_Click()
  Unload Form2
  Unload Form1
  Unload Form2
  Unload Form1
  Unload Form1
  
End Sub
