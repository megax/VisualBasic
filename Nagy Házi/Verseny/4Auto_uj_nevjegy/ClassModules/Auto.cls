VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "Auto"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit
Private WithEvents Timer0 As VB.Timer
Attribute Timer0.VB_VarHelpID = -1
Private WithEvents KVonal1 As VB.Line
Attribute KVonal1.VB_VarHelpID = -1
Private WithEvents KVonal2 As VB.Line
Attribute KVonal2.VB_VarHelpID = -1
Private WithEvents KVonal3 As VB.Line
Attribute KVonal3.VB_VarHelpID = -1
Private WithEvents KVonal4 As VB.Line
Attribute KVonal4.VB_VarHelpID = -1
Private VSzogTomb(1 To 30) As Double
Private Color As ColorConstants
Private Nyomvonal As Boolean
Private Started As Boolean
Private x0 As Double
Private y0 As Double
Private ex As Double
Private ey As Double
Private i As Long
Private Const PontosabbKor = False  ' Ha "true" akkor t�k�letesebben k�z�pen van az aut�. "false" eset�n viszont szerintem �leth�bb.
Private Const xhossz = 80           ' Kocsi hossza.
Private Const yhossz = 60           ' Kocsi sz�less�ge.
Private KorokSzama As Byte
Private EgyKorido As Date ' Egy k�r
Private StopKorido As Date
Private BKorido As Boolean      ' Indul�skor �ll�tja csak be a k�id�t az adott id�re.
Private BStopKorido As Boolean
Private EgySzektorido As Date  ' Egy szektor
Private ASzektorvonal As Boolean ' �tment a szektoron.
Private LegjobbSzektorido(1 To 3) As Single
Private LegjobbKorido As Single
Private LegjobbKoridoSzama As Byte
Private AutoSzama As Byte
Private nyvp As Long
Private GameEnd As Boolean ' V�ge a j�t�knak.
Private UtolsoMeterek As Integer
Private EgyKorHossza As Integer
Private OsszesUt As Integer
Private IndulasStartVonalElol As Boolean ' Startvonal el�li indul�s.

Private Type NyomvonalPontok
    Circle As VB.Shape
    x0 As Double
    y0 As Double
End Type

Private Type Korok
    Korido As Single
    Szektorido(1 To 3) As Single
End Type

Private KorokTomb() As Korok

Public Property Get GetGameEnd() As Boolean
    GetGameEnd = GameEnd
End Property

Public Property Get GetEgyKorHossza() As Integer
    GetEgyKorHossza = EgyKorHossza
End Property

Public Property Get GetOsszesUt() As Integer
    GetOsszesUt = OsszesUt
End Property

Public Property Get GetKorokSzama() As Byte
    GetKorokSzama = KorokSzama
End Property

Public Property Get GetKorSzektoridok(ii As Integer) As Single
    GetKorSzektoridok = KorokTomb(KorokSzama).Szektorido(ii)
End Property

Public Property Get GetOsszKorido() As Single
    Dim osszido As Single, ciklus As Integer

    For ciklus = Palya.GetKezdokorErteke To Config.Globalis_KorokSzama
        osszido = osszido + KorokTomb(ciklus).Korido
    Next ciklus

    GetOsszKorido = osszido
End Property

Public Property Get GetLegjobbKorido() As Single
    GetLegjobbKorido = LegjobbKorido
End Property

Public Property Get GetLegjobbKoridoSzama() As Byte
    GetLegjobbKoridoSzama = LegjobbKoridoSzama
End Property

Public Property Get GetLegjobbSzektoridok(ii As Integer) As Single
    GetLegjobbSzektoridok = LegjobbSzektorido(ii)
End Property

Public Property Get GetKVonal1() As VB.Line
    Set GetKVonal1 = KVonal1
End Property

Public Property Get GetKVonal2() As VB.Line
    Set GetKVonal2 = KVonal2
End Property

Public Property Get GetKVonal3() As VB.Line
    Set GetKVonal3 = KVonal3
End Property

Public Property Get GetKVonal4() As VB.Line
    Set GetKVonal4 = KVonal4
End Property

Public Property Get GetColor() As String
    Dim Szin As String

    Select Case Color
        Case ColorConstants.vbBlue
            Szin = "k�k"
        Case ColorConstants.vbRed
            Szin = "piros"
        Case ColorConstants.vbGreen
            Szin = "z�ld"
        Case ColorConstants.vbYellow
            Szin = "s�rga"
        Case Else
            Szin = "fekete"
    End Select

    GetColor = Szin
End Property

Public Sub SetX0(X As Double)
    x0 = KorrigacioX(X)
End Sub

Public Sub SetY0(Y As Double)
    y0 = KorrigacioY(Y)
End Sub

Public Sub SetEX(X As Double)
    ex = X
End Sub

Public Sub SetEY(Y As Double)
    ey = Y
End Sub

Public Sub SetColor(Szin As String)
    Select Case Szin
        Case "K�k", "k�k"
            Color = ColorConstants.vbBlue
        Case "Piros", "piros"
            Color = ColorConstants.vbRed
        Case "Z�ld", "z�ld"
            Color = ColorConstants.vbGreen
        Case "S�rga", "s�rga"
            Color = ColorConstants.vbYellow
        Case Else
            Color = vbBlack
    End Select

    KVonal1.BorderColor = Color
    KVonal2.BorderColor = Color
    KVonal3.BorderColor = Color
    KVonal4.BorderColor = Color
End Sub

Public Sub SetVisible(visible As Boolean)
    KVonal1.visible = visible
    KVonal2.visible = visible
    KVonal3.visible = visible
    KVonal4.visible = visible
End Sub

Public Sub SetBorderWidth(Nagysag As Byte)
    KVonal1.BorderWidth = Nagysag
    KVonal2.BorderWidth = Nagysag
    KVonal3.BorderWidth = Nagysag
    KVonal4.BorderWidth = Nagysag
End Sub

Public Sub SetNyomvonal(nyom As Boolean)
    Nyomvonal = nyom
End Sub

Public Sub Load(szam As Byte)
    AutoSzama = szam
    Set KVonal1 = Palya.Controls.Add("VB.Line", "KocsiVonal" & szam & "1", Palya.HamisPalya)
    Set KVonal2 = Palya.Controls.Add("VB.Line", "KocsiVonal" & szam & "2", Palya.HamisPalya)
    Set KVonal3 = Palya.Controls.Add("VB.Line", "KocsiVonal" & szam & "3", Palya.HamisPalya)
    Set KVonal4 = Palya.Controls.Add("VB.Line", "KocsiVonal" & szam & "4", Palya.HamisPalya)

    SetVisible True

    Set Timer0 = Palya.Controls.Add("VB.Timer", "Timer" & szam & "1", Palya)
    Timer0.Enabled = False
    Timer0.Interval = 50 + Rnd * 21

    Dim ciklus As Long
    For ciklus = 1 To 30
        VSzogTomb(ciklus) = Rnd * 0.1
    Next ciklus
End Sub

Public Sub Start()
    If Started Or GameEnd Then
        Exit Sub
    End If

    If BKorido Then
        EgyKorido = Now
        EgySzektorido = EgyKorido
        BKorido = False
    End If

    Started = True
    Timer0.Enabled = True
End Sub

Public Sub Stop_Kocsi()
    If Not Started Or GameEnd Then
        Exit Sub
    End If

    Started = False
    StopKorido = Now
    BStopKorido = True
    Timer0.Enabled = False
End Sub

Private Sub Class_Initialize()
    Dim ciklus As Integer

    ex = 0.6
    ey = -1
    x0 = KorrigacioX(1100)
    y0 = KorrigacioY(4000)
    nyvp = 0
    BKorido = True
    GameEnd = False
    BStopKorido = False
    IndulasStartVonalElol = False
    KorokSzama = Palya.GetKezdokorErteke()
    SetNyomvonal True
    ASzektorvonal = False
    ReDim KorokTomb(Palya.GetKezdokorErteke() To Config.Globalis_KorokSzama) As Korok

    LegjobbKorido = 1000   ' Kezd��rt�k

    For ciklus = LBound(LegjobbSzektorido) To UBound(LegjobbSzektorido)
        LegjobbSzektorido(ciklus) = 10000000  ' Kezd��rt�k
    Next ciklus
End Sub

Private Sub Class_Terminate()
    Set KVonal1 = Nothing
    Set KVonal2 = Nothing
    Set KVonal3 = Nothing
    Set KVonal4 = Nothing
    Set Timer0 = Nothing
End Sub

Public Sub Dispose()
    Dim i As Long
    For i = 1 To 4
        Palya.Controls.Remove "KocsiVonal" & AutoSzama & i
    Next i

    Palya.Controls.Remove "Timer" & AutoSzama & "1"
End Sub

Public Sub Show()
    NextMove
End Sub

Private Sub Timer0_Timer()
    i = i + 1

    If i > 30 Then
        i = 1

        Randomize
        Timer0.Interval = 50 + Rnd * 21
    End If

    If BStopKorido Then
        Dim NowTime As Date
        NowTime = Now
        EgyKorido = DateAdd("s", DateDiff("s", StopKorido, NowTime), EgyKorido)
        EgySzektorido = DateAdd("s", DateDiff("s", StopKorido, NowTime), EgySzektorido)
        BStopKorido = False
    End If

    NextCoordinate True, True

    Dim xb As Single, yb As Single, xj As Single, yj As Single
    ' Ide�lisan k�z�pen van �gy a j�rm�.
    If PontosabbKor Then
        xb = x0 + xhossz * ex - yhossz * ey
        yb = y0 + xhossz * ey + yhossz * ex
        xj = x0 + xhossz * ex + yhossz * ey
        yj = y0 + xhossz * ey - yhossz * ex
    Else
        xb = x0 + 400 * ex - 300 * ey
        yb = y0 + 400 * ey + 300 * ex
        xj = x0 + 400 * ex + 300 * ey
        yj = y0 + 400 * ey - 300 * ex
    End If

    Dim distb As Single, distj As Single, ciklus As Integer
    distb = 1000000
    distj = 1000000

    For ciklus = LBound(PalyaInfo.PalyaVonalTomb) To PalyaInfo.PalyaVonalakSzama - 1
        Dim db As Single, dj As Single
        db = Distance(xb, yb, KorrigacioX(PalyaInfo.PalyaVonalTomb(ciklus).X1), KorrigacioX(PalyaInfo.PalyaVonalTomb(ciklus).X2), KorrigacioY(PalyaInfo.PalyaVonalTomb(ciklus).Y1), KorrigacioY(PalyaInfo.PalyaVonalTomb(ciklus).Y2))
        dj = Distance(xj, yj, KorrigacioX(PalyaInfo.PalyaVonalTomb(ciklus).X1), KorrigacioX(PalyaInfo.PalyaVonalTomb(ciklus).X2), KorrigacioY(PalyaInfo.PalyaVonalTomb(ciklus).Y1), KorrigacioY(PalyaInfo.PalyaVonalTomb(ciklus).Y2))

        If distb > db Then
            distb = db
        End If

        If distj > dj Then
            distj = dj
        End If
    Next ciklus

    ' Ide�lisan k�z�pen van �gy a j�rm�.
    If PontosabbKor Then
        If distb - distj > 0 And distb - distj < 200 Then
            NextCoordinate False, False
            NextMove
        ElseIf distj - distb > 0 And distj - distb < 200 Then
            NextCoordinate True, False
            NextMove
        End If
    Else
        If distb < 200 Then
            NextCoordinate True, False
            NextMove
        ElseIf distb > 200 Then
            NextCoordinate False, False
            NextMove
        Else
            x0 = x0 - 55 * ex
            y0 = y0 - 55 * ey
        End If
    End If
    
    NextMove

    x0 = x0 + 50 * ex
    y0 = y0 + 50 * ey
    NextMove

    Szektorok

    If Nyomvonal Then
        Palya.HamisPalya.Circle (x0, y0), 10, Color
    End If

    If KorokSzama = Palya.GetKezdokorErteke And IndulasStartVonalElol Then
        EgyKorHossza = EgyKorHossza + Palya.GetPalyaHosszanakLepteke ' M�terben van �rtve.
    End If

    OsszesUt = OsszesUt + Palya.GetPalyaHosszanakLepteke         ' M�terben van �rtve.

    If GameEnd Then
        UtolsoMeterek = UtolsoMeterek + 1

        If UtolsoMeterek = 20 Then
            Timer0.Enabled = False
        End If
    End If
End Sub

' Korrig�lja az X elt�r�st.
Private Function KorrigacioX(ByVal PointX As Single) As Single
    KorrigacioX = PointX - Palya.HamisPalya.Left
End Function

' Korrig�lja az Y elt�r�st.
Private Function KorrigacioY(ByVal PointY As Single) As Single
    KorrigacioY = PointY - Palya.HamisPalya.Top
End Function

Private Sub NextCoordinate(BIrany As Boolean, VSzog As Boolean)
    Dim bj As Double

    If BIrany Then
        bj = -0.15
    Else
        bj = 0.15
    End If

    If VSzog Then
        ex = Cos(VSzogTomb(i)) * ex - Sin(VSzogTomb(i)) * ey
        ey = Cos(VSzogTomb(i)) * ey + Sin(VSzogTomb(i)) * ex
    Else
        ex = Cos(bj) * ex - Sin(bj) * ey
        ey = Cos(bj) * ey + Sin(bj) * ex
    End If

    ex = ex / Sqr(ex * ex + ey * ey)
    ey = ey / Sqr(ex * ex + ey * ey)
End Sub

Private Sub NextMove()
    KVonal1.X1 = x0 + xhossz * ex - yhossz * ey
    KVonal1.Y1 = y0 + xhossz * ey + yhossz * ex
    KVonal1.X2 = x0 - xhossz * ex - yhossz * ey
    KVonal1.Y2 = y0 - xhossz * ey + yhossz * ex

    KVonal2.X1 = x0 + xhossz * ex + yhossz * ey
    KVonal2.Y1 = y0 + xhossz * ey - yhossz * ex
    KVonal2.X2 = x0 - xhossz * ex + yhossz * ey
    KVonal2.Y2 = y0 - xhossz * ey - yhossz * ex

    KVonal3.X1 = KVonal1.X1
    KVonal3.X2 = KVonal2.X1
    KVonal3.Y1 = KVonal1.Y1
    KVonal3.Y2 = KVonal2.Y1

    KVonal4.X1 = KVonal1.X2
    KVonal4.X2 = KVonal2.X2
    KVonal4.Y1 = KVonal1.Y2
    KVonal4.Y2 = KVonal2.Y2
End Sub

' K�t szektorid� m�r�se �rtelemszer�en t�vols�g alapj�n ha el�rte.
' 0-t�l 1-ig tartanak a szektorvonalak mert a c�lvonal egyben a harmadik szektor.
Private Sub Szektorok()
    If KorokSzama > Config.Globalis_KorokSzama Then
        Exit Sub
    End If

    Dim NextKor As Boolean, ii As Byte
    For ii = LBound(KorokTomb(KorokSzama).Szektorido) To UBound(KorokTomb(KorokSzama).Szektorido)
        Dim Dist As Single, ciklus As Byte, szam As Byte
        Dist = 1000000

        For ciklus = LBound(PalyaInfo.SzektorVonalTomb) To PalyaInfo.SzektorVonalakSzama - 1
            Dim d As Single
            d = Distance(x0, y0, KorrigacioX(PalyaInfo.SzektorVonalTomb(ciklus).X1), KorrigacioX(PalyaInfo.SzektorVonalTomb(ciklus).X2), KorrigacioY(PalyaInfo.SzektorVonalTomb(ciklus).Y1), KorrigacioY(PalyaInfo.SzektorVonalTomb(ciklus).Y2))

            If Dist > d Then
                Dist = d
                szam = ciklus + 1 ' Mert egyel magasabbon vannak
            End If
        Next ciklus

        If Dist < 100 And Not ASzektorvonal Then
            Dim NowTime As Date
            NowTime = Now
            ASzektorvonal = True

            If Not IndulasStartVonalElol Then
                IndulasStartVonalElol = True
                Exit Sub
            End If

            For ciklus = LBound(SorrendTomb(KorokSzama).Szektor(szam).Autok) To UBound(SorrendTomb(KorokSzama).Szektor(szam).Autok)
                If Not SorrendTomb(KorokSzama).Szektor(szam).VanAdat Then
                    SorrendTomb(KorokSzama).Szektor(szam).VanAdat = True
                End If

                If SorrendTomb(KorokSzama).Szektor(szam).Autok(ciklus).Szin = "" Then
                    SorrendTomb(KorokSzama).Szektor(szam).Autok(ciklus).Szin = GetColor
                    SorrendTomb(KorokSzama).Szektor(szam).Autok(ciklus).Ido = NowTime
                    Exit For
                End If
            Next ciklus

            If szam = 3 Then
                NextKor = True
                KorokTomb(KorokSzama).Korido = DateDiff("s", EgyKorido, NowTime)

                If LegjobbKorido > KorokTomb(KorokSzama).Korido Then
                    LegjobbKorido = KorokTomb(KorokSzama).Korido
                    LegjobbKoridoSzama = KorokSzama
                End If

                KorokTomb(KorokSzama).Szektorido(szam) = KorokTomb(KorokSzama).Korido

                Dim j As Byte
                For j = LBound(KorokTomb(KorokSzama).Szektorido) To UBound(KorokTomb(KorokSzama).Szektorido) - 1 ' Mert utols�t nem akarjuk kivonni
                    KorokTomb(KorokSzama).Szektorido(szam) = KorokTomb(KorokSzama).Szektorido(szam) - KorokTomb(KorokSzama).Szektorido(j)
                Next j
            Else
                KorokTomb(KorokSzama).Szektorido(szam) = DateDiff("s", EgySzektorido, NowTime)
            End If

            If LegjobbSzektorido(szam) > KorokTomb(KorokSzama).Szektorido(szam) Then
                LegjobbSzektorido(szam) = KorokTomb(KorokSzama).Szektorido(szam)
            End If

            NowTime = Now

            If szam = 3 Then
                EgyKorido = NowTime
            End If

            EgySzektorido = NowTime
        ElseIf Dist > 100 And ASzektorvonal Then
            ASzektorvonal = False
        End If
    Next ii

    If NextKor Then
        KorokSzama = KorokSzama + 1
    End If

    If KorokSzama > Config.Globalis_KorokSzama Then
        GameEnd = True
    End If
End Sub
