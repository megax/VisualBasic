VERSION 5.00
Begin VB.Form WarningNewGame 
   BackColor       =   &H8000000E&
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Figyelmeztet�s: �j j�t�k"
   ClientHeight    =   1485
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   10455
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   1485
   ScaleWidth      =   10455
   StartUpPosition =   2  'CenterScreen
   Begin VB.PictureBox FigyelmeztetoJel 
      Appearance      =   0  'Flat
      AutoSize        =   -1  'True
      BackColor       =   &H80000005&
      BorderStyle     =   0  'None
      ForeColor       =   &H80000008&
      Height          =   780
      Left            =   120
      Picture         =   "WarningNewGame.frx":0000
      ScaleHeight     =   780
      ScaleWidth      =   795
      TabIndex        =   5
      Top             =   0
      Width           =   795
   End
   Begin VB.CommandButton CmdMegse 
      Caption         =   "M�gse"
      Height          =   375
      Left            =   6000
      TabIndex        =   3
      Top             =   960
      Width           =   1335
   End
   Begin VB.CommandButton CmdNem 
      Caption         =   "Nem"
      Height          =   375
      Left            =   4560
      TabIndex        =   2
      Top             =   960
      Width           =   1335
   End
   Begin VB.CommandButton CmdIgen 
      Caption         =   "Igen"
      Height          =   375
      Left            =   3120
      TabIndex        =   1
      Top             =   960
      Width           =   1335
   End
   Begin VB.Label Label2 
      AutoSize        =   -1  'True
      BackColor       =   &H8000000E&
      Caption         =   "befejezett j�t�k v�geredm�ny�t. K�v�nja elmenteni?"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   12
         Charset         =   238
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   300
      Left            =   1080
      TabIndex        =   4
      Top             =   480
      Width           =   6405
   End
   Begin VB.Label Label1 
      AutoSize        =   -1  'True
      BackColor       =   &H8000000E&
      Caption         =   "Figyelem! �j j�t�kot szeretne ind�tani de m�g nem mentette el az el�z�leg"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   12
         Charset         =   238
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   300
      Left            =   1080
      TabIndex        =   0
      Top             =   120
      Width           =   9195
   End
End
Attribute VB_Name = "WarningNewGame"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
' Fejl�c
' K�sz�tette: Salamon Valter
' Fejl�c v�ge

Option Explicit

' CmdIgen gomb esem�nye kattint�s hat�s�ra.
Private Sub CmdIgen_Click()
    ' V�geredm�ny ment�se.
    VegeredmenyMentese.Save
    ' �j j�t�k ind�t�s�nak enged�lyez�se.
    NewGameEnabled = True
    ' �j j�t�k ind�t�sa.
    Palya.NewGame_Click
    ' Form bez�r�sa.
    Unload Me
End Sub

' CmdNem gomb esem�nye kattint�s hat�s�ra.
Private Sub CmdNem_Click()
    ' �j j�t�k ind�t�s�nak enged�lyez�se.
    NewGameEnabled = True
    ' �j j�t�k ind�t�sa.
    Palya.NewGame_Click
    ' Form bez�r�sa.
    Unload Me
End Sub

' CmdMegse gomb esem�nye kattint�s hat�s�ra.
Private Sub CmdMegse_Click()
    ' �j j�t�k ind�t�s�nak tilt�sa.
    NewGameEnabled = False
    ' Form bez�r�sa.
    Unload Me
End Sub
