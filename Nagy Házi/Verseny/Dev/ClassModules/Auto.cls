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
' Fejl�c
' K�sz�tette: Jakosa Csaba �rp�d
' Fejl�c v�ge

Option Explicit

' Az aut� elhelyezked�s�t friss�ti.
Private WithEvents Timer0 As VB.Timer
Attribute Timer0.VB_VarHelpID = -1
' A kocsi n�gy vonal�t t�rolja.
Private KVonalTomb(1 To 4) As VB.Line
' V�letlen nagys�g� sz�vegeket t�rol.
Private VSzogTomb(1 To 30) As Single
' T�rolja az aut� sz�n�t.
Private Color As ColorConstants
' T�rolja hogy be illetve ki van-e kapcsolva a nyomvonal.
Private Nyomvonal As Boolean
' T�rolja hogy megy-e az aut� vagy sem.
Private Started As Boolean
' X0 koordin�ta.
Private x0 As Double
' Y0 koordin�ta.
Private y0 As Double
Private ex As Double
Private ey As Double
' L�pt�ket t�rol. A megadott l�pt�k ut�n majd a k�d egyes r�szei v�ltoz�sokat id�znek el�.
Private i As Integer
' Ha "true" akkor t�k�letesebben k�z�pen van az aut�. "false" eset�n viszont szerintem �leth�bb.
Private PontosabbKor As Boolean
' Kocsi hossza.
Private Const xhossz = 80
' Kocsi sz�less�ge.
Private Const yhossz = 60
' T�rolja a k�r�k sz�m�t.
Private KorokSzama As Byte
' Egy k�r idej�nek hossza.
Private EgyKorido As Date
' T�rolja azt az id�t ameddig az aut� meg lett �ll�tva.
Private StopKorido As Date
' Indul�skor a k�rid� be�ll�t�s�ban seg�t� v�ltoz�.
Private BKorido As Boolean
' Meg�ll�st jelz� v�ltoz�.
Private BStopKorido As Boolean
' Egy szektor idej�nek hossza.
Private EgySzektorido As Date
' T�rolja hogy az aut� �tment-e az egyik szetoron vagy sem.
Private ASzektorvonal As Boolean
' T�rolja a h�rom legjobb szektorid�t.
Private LegjobbSzektorido(1 To 3) As Single
' T�rolja a legjobb k�rid�t.
Private LegjobbKorido As Single
' T�rolja melyik k�rben lett be�ll�tva a legjobb k�rid�.
Private LegjobbKoridoSzama As Byte
' T�rolja h�nyas sz�m� aut�.
Private AutoSzama As Byte
' T�rolja v�ge van-e a j�t�knak vagy sem.
Private GameEnd As Boolean
' Ha v�ge a j�t�knak akkor ez a v�ltoz� t�rolja m�g mennyit fog az aut� menni a p�ly�n.
Private UtolsoMeterek As Integer
' T�rolja egy k�r hossz�t.
Private EgyKorHossza As Integer
' T�rolja az �sszes megtett �tat.
Private OsszesUt As Integer
' Seg�ti a startvonal el�li indul�st.
Private IndulasStartVonalElol As Boolean

' T�rolja a k�r�k egyes adatait.
Private Type Korok
    ' T�rolja a k�rid�t.
    Korido As Single
    ' T�rolja a h�rom szektorid�t.
    Szektorido(1 To 3) As Single
End Type

' T�rolja a k�r�ket t�mbben.
Private KorokTomb() As Korok

' Publikus v�ltoz�k.

' Visszadja publikusan hogy az aut� befejezte-e a j�t�kot.
Public Property Get GetGameEnd() As Boolean
    ' �rt�k be�ll�t�sa.
    GetGameEnd = GameEnd
End Property

' Visszadja publikusan egy k�r hossz�t.
Public Property Get GetEgyKorHossza() As Integer
    ' �rt�k be�ll�t�sa.
    GetEgyKorHossza = EgyKorHossza
End Property

' Visszadja publikusan az �sszes megtett �tat.
Public Property Get GetOsszesUt() As Integer
    ' �rt�k be�ll�t�sa.
    GetOsszesUt = OsszesUt
End Property

' Visszadja publikusan a k�r�k sz�m�t.
Public Property Get GetKorokSzama() As Byte
    ' �rt�k be�ll�t�sa.
    GetKorokSzama = KorokSzama
End Property

' Visszadja publikus v�ltoz�k�nt a k�r adott szektoridej�t.
' Az "si" tartalmazza a szektor sz�m�t.
Public Property Get GetKorSzektoridok(ByVal si As Integer) As Single
    ' �rt�k be�ll�t�sa.
    GetKorSzektoridok = KorokTomb(KorokSzama).Szektorido(si)
End Property

' Visszadja publikusan az �sszes k�rid�t.
Public Property Get GetOsszKorido() As Single
    ' T�rolja az �sszes k�rid�t.
    Dim osszido As Single
    ' "ciklus" seg�dv�ltoz� a ciklushoz.
    Dim ciklus As Integer

    For ciklus = Palya.GetKezdokorErteke To Config.Globalis_KorokSzama
        ' �sszes id� �sszead�sa.
        osszido = osszido + KorokTomb(ciklus).Korido
    Next ciklus

    ' �rt�k be�ll�t�sa.
    GetOsszKorido = osszido
End Property

' Visszadja publikusan a legjobb k�rid�t.
Public Property Get GetLegjobbKorido() As Single
    ' �rt�k be�ll�t�sa.
    GetLegjobbKorido = LegjobbKorido
End Property

' Visszadja publikusan a legjobb k�rid� k�r�nek sz�m�t.
Public Property Get GetLegjobbKoridoSzama() As Byte
    ' �rt�k be�ll�t�sa.
    GetLegjobbKoridoSzama = LegjobbKoridoSzama
End Property

' Visszadja publikus v�ltoz�k�nt a legjobb szektorid�t.
' Az "si" tartalmazza a szektor sz�m�t.
Public Property Get GetLegjobbSzektoridok(ByVal si As Integer) As Single
    ' �rt�k be�ll�t�sa.
    GetLegjobbSzektoridok = LegjobbSzektorido(si)
End Property

' Visszadja publikus v�ltoz�k�nt a be�ll�tott sz�nt.
Public Property Get GetColor() As String
    ' T�rolja a sz�nt.
    Dim Szin As String

    ' V�laszt�s sz�n alapj�n.
    Select Case Color
        Case ColorConstants.vbBlue
            ' Sz�n be�ll�t�sa.
            Szin = "k�k"
        Case ColorConstants.vbRed
            ' Sz�n be�ll�t�sa.
            Szin = "piros"
        Case ColorConstants.vbGreen
            ' Sz�n be�ll�t�sa.
            Szin = "z�ld"
        Case ColorConstants.vbYellow
            ' Sz�n be�ll�t�sa.
            Szin = "s�rga"
        Case ColorConstants.vbBlack
            ' Sz�n be�ll�t�sa.
            Szin = "fekete"
        Case Else
            ' Sz�n be�ll�t�sa.
            Szin = "fekete"
    End Select

    ' �rt�k be�ll�t�sa.
    GetColor = Szin
End Property

' Visszadja publikus v�ltoz�k�nt az X0 koordin�t�t.
Public Property Get GetX0() As Double
    ' �rt�k be�ll�t�sa.
    GetX0 = x0
End Property

' Visszadja publikus v�ltoz�k�nt az Y0 koordin�t�t.
Public Property Get GetY0() As Double
    ' �rt�k be�ll�t�sa.
    GetY0 = y0
End Property

' Be�ll�that� vele az X0 koordin�ta.
' Az "X" tartalmazza a koordin�t�t.
Public Sub SetX0(ByVal X As Double)
    ' �rt�k be�ll�t�sa.
    x0 = KorrigacioX(X)
End Sub

' Be�ll�that� vele az Y0 koordin�ta.
' Az "Y" tartalmazza a koordin�t�t.
Public Sub SetY0(ByVal Y As Double)
    ' �rt�k be�ll�t�sa.
    y0 = KorrigacioY(Y)
End Sub

' Be�ll�that� vele az EX koordin�ta.
' Az "X" tartalmazza a koordin�t�t.
Public Sub SetEX(ByVal X As Double)
    ' �rt�k be�ll�t�sa.
    ex = X
End Sub

' Be�ll�that� vele az EY koordin�ta.
' Az "Y" tartalmazza a koordin�t�t.
Public Sub SetEY(ByVal Y As Double)
    ' �rt�k be�ll�t�sa.
    ey = Y
End Sub

' Be�ll�that� vele az aut� vonalainak sz�ne.
' A "Szin" t�rolja milyen sz�n� legyen.
Public Sub SetColor(ByVal Szin As String)
    ' Kiv�lasztja a megfelel� sz�nt.
    Select Case Szin
        Case "K�k", "k�k"
            ' Sz�n be�ll�t�sa.
            Color = ColorConstants.vbBlue
        Case "Piros", "piros"
            ' Sz�n be�ll�t�sa.
            Color = ColorConstants.vbRed
        Case "Z�ld", "z�ld"
            ' Sz�n be�ll�t�sa.
            Color = ColorConstants.vbGreen
        Case "S�rga", "s�rga"
            ' Sz�n be�ll�t�sa.
            Color = ColorConstants.vbYellow
        Case "Fekete", "fekete"
            ' Sz�n be�ll�t�sa.
            Color = ColorConstants.vbBlack
        Case Else
            ' Sz�n be�ll�t�sa.
            Color = ColorConstants.vbBlack
    End Select

    ' "ciklus" seg�dv�ltoz� a ciklushoz.
    Dim ciklus As Byte
    For ciklus = LBound(KVonalTomb) To UBound(KVonalTomb)
        ' �rt�k be�ll�t�sa.
        KVonalTomb(ciklus).BorderColor = Color
    Next ciklus
End Sub

' A vonalak l�that�s�g�t lehet be�ll�tani vele.
' A "Visible" t�rolja hogy l�that� vagy l�thatatlan legyen-e a vonal.
Public Sub SetVisible(ByVal Visible As Boolean)
    ' "ciklus" seg�dv�ltoz� a ciklushoz.
    Dim ciklus As Byte
    For ciklus = LBound(KVonalTomb) To UBound(KVonalTomb)
        ' �rt�k be�ll�t�sa.
        KVonalTomb(ciklus).Visible = Visible
    Next ciklus
End Sub

' Be�ll�that� vele a kocsi vonal�nak vastags�ga.
' A "Nagysag" tartalmazza a vonal m�ret�t.
Public Sub SetBorderWidth(ByVal Nagysag As Byte)
    ' "ciklus" seg�dv�ltoz� a ciklushoz.
    Dim ciklus As Byte
    For ciklus = LBound(KVonalTomb) To UBound(KVonalTomb)
        ' �rt�k be�ll�t�sa.
        KVonalTomb(ciklus).BorderWidth = Nagysag
    Next ciklus
End Sub

' Nyomvonal be illetve kikapcsolol�s�nak lehet�s�ge.
' A "Nyom" tartalmazza azt hogy be vagy ki legyen-e kapcsolva.
Public Sub SetNyomvonal(ByVal Nyom As Boolean)
    ' �rt�k be�ll�t�sa.
    Nyomvonal = Nyom
End Sub

' Be illetve kikapcsolhat�v� teszi hogy egy pontosabb k�rt �rjon le az aut�.
' A "PKor" tartalmazza hogy be illetve ki legyen-e kapcsolva ez a lehet�s�g.
Public Sub SetPontosabbKor(ByVal PKor As Boolean)
    ' �rt�k be�ll�t�sa.
    PontosabbKor = PKor
End Sub

' Publikus v�ltoz�k v�ge.

' Bet�lti az aut� egyedi inform�ci�it.
' A "Szam" tartalmazza h�nyas sz�m� aut�k�nt fog indulni.
Public Sub Load(ByVal Szam As Byte)
    ' Aut� sz�m�nak elment�se.
    AutoSzama = Szam

    ' "ciklus" seg�dv�ltoz� a ciklushoz.
    Dim ciklus As Byte
    For ciklus = LBound(KVonalTomb) To UBound(KVonalTomb)
        ' Kocsi vonal l�trehoz�sa.
        Set KVonalTomb(ciklus) = Palya.Controls.Add("VB.Line", "KocsiVonal" & Szam & CStr(ciklus), Palya.VirtualisPalya)
    Next ciklus

    ' L�that�s�g be�ll�t�sa.
    SetVisible True

    ' Id�z�t� l�trehoz�sa.
    Set Timer0 = Palya.Controls.Add("VB.Timer", "Timer" & Szam & "1", Palya)
    ' Id�z�t� kikapcsol�sa.
    Timer0.Enabled = False

    Randomize
    ' �rt�k be�ll�t�sa. 50-71 millisec (V�letlen sz�m.)
    Timer0.Interval = Int(50 + Rnd * 21)

    For ciklus = LBound(VSzogTomb) To UBound(VSzogTomb)
        Randomize
        ' V�letlen nagys�g� sz�g l�trehoz�sa.
        VSzogTomb(ciklus) = CSng(Rnd * 0.1)
    Next ciklus
End Sub

' Aut� elind�t�sa.
Public Sub Start()
    ' Akkor fut le ha az aut� m�r megy vagy m�r befejezte a j�t�kot.
    If Started Or GameEnd Then
        ' Kil�p�s az elj�r�sb�l.
        Exit Sub
    End If

    ' Akkor fut le ha �j k�rid�t kell be�ll�tani teh�t igaz az �rt�ke.
    If BKorido Then
        ' Jelenlegi id� be�ll�t�sa.
        EgyKorido = Now
        ' Az "EgyKorido" idej�nek �tm�sol�sa.
        EgySzektorido = EgyKorido
        ' �rt�k hamisra �ll�t�sa.
        BKorido = False
    End If

    ' �rt�k igazra �ll�t�sa. Az aut� indul.
    Started = True
    ' Id�z�t� elind�t�sa.
    Timer0.Enabled = True
End Sub

' Aut� meg�ll�t�sa.
Public Sub Stop_Kocsi()
    ' Akkor fut le ha az aut� m�g nem fut vagy v�ge az aut� j�t�k�nak.
    If Not Started Or GameEnd Then
        ' Kil�p�s az elj�r�sb�l.
        Exit Sub
    End If

    ' Aut� meg�ll�t�sa.
    Started = False
    ' Jelenlegi id� be�ll�t�sa.
    StopKorido = Now
    ' Meg�ll�st jelz� v�ltoz� igazra �ll�t�sa �s az �ll�st m�r� v�ltoz�k bekapcsol�sa.
    BStopKorido = True
    ' Id�z�t� le�ll�t�sa.
    Timer0.Enabled = False
End Sub

' Be�ll�tjuk a form l�trehoz�sakor az alap folyamatokat.
Private Sub Class_Initialize()
    ' Alap�rtelmezett �rt�k be�ll�t�sa.
    ex = 0.6
    ' Alap�rtelmezett �rt�k be�ll�t�sa.
    ey = -1
    ' Alap�rtelmezett �rt�k be�ll�t�sa.
    x0 = KorrigacioX(1100)
    ' Alap�rtelmezett �rt�k be�ll�t�sa.
    y0 = KorrigacioY(5000)
    ' K�rid� m�rt�s�nek enged�lyez�se.
    BKorido = True
    ' Aut� j�t�k�nak befejzt�t jelz� v�ltoz� hamisra �ll�t�sa.
    GameEnd = False
    ' Aut� meg�ll�s�t jelz� v�ltoz� hamisra �ll�t�sa.
    BStopKorido = False
    ' Az els� vonaltol val� indul�st jelz� v�ltoz� hamisra �ll�t�sa.
    IndulasStartVonalElol = False
    ' Kezd�k�r be�ll�t�sa.
    KorokSzama = Palya.GetKezdokorErteke()
    ' Nyomvonal bekapcsol�sa.
    SetNyomvonal True
    ' Pontosabb k�r�z�s kikapcsol�sa.
    SetPontosabbKor False
    ' Szektorvonalon val� �tmenetel hamisra �ll�t�sa.
    ASzektorvonal = False
    ' T�mbben t�rol k�r�k t�rl�se �s �jradimenzion�l�sa.
    ReDim KorokTomb(Palya.GetKezdokorErteke() To Config.Globalis_KorokSzama) As Korok

    ' Kezd��rt�k be�ll�t�sa.
    LegjobbKorido = KezdoSzektorido
    ' Kezd��rt�k be�ll�t�sa.
    i = LBound(VSzogTomb)

    ' "ciklus" seg�dv�ltoz� a ciklushoz.
    Dim ciklus As Integer
    For ciklus = LBound(LegjobbSzektorido) To UBound(LegjobbSzektorido)
        ' Kezd��rt�k be�ll�t�sa.
        LegjobbSzektorido(ciklus) = KezdoSzektorido
    Next ciklus
End Sub

' Class megsz�n�sekor bizonyos dolgok megsemis�t�sre ker�lnek.
Private Sub Class_Terminate()
    ' "ciklus" seg�dv�ltoz� a ciklushoz.
    Dim ciklus As Byte
    For ciklus = LBound(KVonalTomb) To UBound(KVonalTomb)
        ' Null�z�s.
        Set KVonalTomb(ciklus) = Nothing
    Next ciklus

    ' Null�z�s.
    Set Timer0 = Nothing
End Sub

' T�rli az egyes inform�ci�kat a kocsikr�l. Megsemmis�ti �ket.
Public Sub Dispose()
    ' "ciklus" seg�dv�ltoz� a ciklushoz.
    Dim ciklus As Byte
    For ciklus = LBound(KVonalTomb) To UBound(KVonalTomb)
        ' T�rli a kocsi vonal�t a p�ly�r�l.
        Palya.Controls.Remove KVonalTomb(ciklus)
    Next ciklus

    ' T�rli az id�z�t�t.
    Palya.Controls.Remove Timer0
End Sub

' Megjelen�ti az aut�t.
Public Sub Show()
    ' Aut� vonalainak mozgat�sa a k�vetkez� koordin�t�kra.
    NextMove
End Sub

' Korrig�lja az X elt�r�st.
' A "PointX" t�rolja hol tal�lhat� az X koordin�ta.
Private Function KorrigacioX(ByVal PointX As Single) As Single
    ' A virtu�lis p�lya x tengely t�vols�g�nak levon�sa.
    KorrigacioX = PointX - Palya.VirtualisPalya.Left
End Function

' Korrig�lja az Y elt�r�st.
' A "PointY" t�rolja hol tal�lhat� az Y koordin�ta.
Private Function KorrigacioY(ByVal PointY As Single) As Single
    ' A virtu�lis p�lya y tengely t�vols�g�nak levon�sa.
    KorrigacioY = PointY - Palya.VirtualisPalya.Top
End Function

' K�t szektorid� m�r�se �rtelemszer�en t�vols�g alapj�n ha el�rte.
' 0-t�l 1-ig tartanak a szektorvonalak mert a c�lvonal egyben a harmadik szektor.
Private Sub Szektorok()
    ' Akkor fut le ha a k�r�k sz�ma m�r nagyobb mint ami be lett �ll�tva a konfigban.
    If KorokSzama > Config.Globalis_KorokSzama Then
        ' Kil�p�s az elj�r�sb�l.
        Exit Sub
    End If

    ' T�rolja hogy �j k�r kezd�dik-e.
    Dim NextKor As Boolean
    ' "ii" seg�dv�ltoz� a ciklushoz.
    Dim ii As Byte

    For ii = LBound(KorokTomb(KorokSzama).Szektorido) To UBound(KorokTomb(KorokSzama).Szektorido)
        ' T�rolja a szektorvonalt�l val� t�vols�got.
        Dim dist As Single
        ' "ciklus" seg�dv�ltoz� a ciklushoz.
        Dim ciklus As Byte
        ' T�rolja a szektor sz�m�t.
        Dim Szam As Byte
        ' Kezd��rt�k be�ll�t�sa a t�vols�gnak.
        dist = KezdoTavolsagPontok

        For ciklus = LBound(PalyaInfo.SzektorVonalTomb) To PalyaInfo.SzektorVonalakSzama - 1
            ' Kocsivonal t�vols�g�nak seg�dv�ltoz�ja.
            Dim d As Single
            ' T�vols�g be�ll�t�sa.
            d = Distance(x0, y0, KorrigacioX(PalyaInfo.SzektorVonalTomb(ciklus).X1), KorrigacioX(PalyaInfo.SzektorVonalTomb(ciklus).X2), KorrigacioY(PalyaInfo.SzektorVonalTomb(ciklus).Y1), KorrigacioY(PalyaInfo.SzektorVonalTomb(ciklus).Y2))

            ' A legkisebb t�vols�got keresi.
            If dist > d Then
                ' �rt�k be�l�lt�sa.
                dist = d
                ' Szektor sz�m�nak be�ll�t�sa.
                Szam = ciklus + 1
            End If
        Next ciklus

        ' Akkor fut le ha a t�vols�g kisebb mint 100 �s nem ment �t az aut� egy szektorvonalon se.
        If dist < 100 And Not ASzektorvonal Then
            ' T�rolni fogja a jelenlegi id�t.
            Dim NowTime As Date
            ' Jelenlegi id� be�ll�t�sa.
            NowTime = Now
            ' A szektorvonalon val� �tmen�s igazra �ll�t�sa.
            ASzektorvonal = True

            ' Akkor fut le ha nem a startvonal el�t van az aut�.
            If Not IndulasStartVonalElol Then
                ' Most m�r a start vonal ut�n lesz.
                IndulasStartVonalElol = True
                ' Kil�p�s az elj�r�sb�l.
                Exit Sub
            End If

            For ciklus = LBound(PalyaInfo.SorrendTomb(KorokSzama).Szektor(Szam).Autok) To UBound(PalyaInfo.SorrendTomb(KorokSzama).Szektor(Szam).Autok)
                ' Akkor fut le ha m�g nincs adat az adott szektorban.
                If Not PalyaInfo.SorrendTomb(KorokSzama).Szektor(Szam).VanAdat Then
                    ' �rt�k igazra �ll�t�sa.
                    PalyaInfo.SorrendTomb(KorokSzama).Szektor(Szam).VanAdat = True
                End If

                ' Akkor fut le ha az aut� sz�ne m�g nincs be�ll�tva a szektorban.
                If PalyaInfo.SorrendTomb(KorokSzama).Szektor(Szam).Autok(ciklus).Szin = "" Then
                    ' Sz�n be�ll�t�sa.
                    PalyaInfo.SorrendTomb(KorokSzama).Szektor(Szam).Autok(ciklus).Szin = GetColor
                    ' Id� be�ll�t�sa.
                    PalyaInfo.SorrendTomb(KorokSzama).Szektor(Szam).Autok(ciklus).Ido = NowTime
                    ' Kil�p�s a ciklusb�l.
                    Exit For
                End If
            Next ciklus

            ' Akkor fut le ha a harmadik c�lvonalon ment �t az aut�. Az az a c�lvonalon.
            If Szam = 3 Then
                ' �j k�r lehet�s�g�nek enged�lyez�se.
                NextKor = True
                ' K�rid� be�ll�t�sa.
                KorokTomb(KorokSzama).Korido = DateDiff("s", EgyKorido, NowTime)

                ' Akkor fut le ha az aut� k�rideje jobb mint a r�gi.
                If LegjobbKorido > KorokTomb(KorokSzama).Korido Then
                    ' �j legjobb k�rid� be�ll�t�sa.
                    LegjobbKorido = KorokTomb(KorokSzama).Korido
                    ' Legjobb k�rid� k�r sz�m�nak be�ll�t�sa.
                    LegjobbKoridoSzama = KorokSzama
                End If

                ' Teljes k�rid� be�ll�t�sa az utols� szektornak.
                KorokTomb(KorokSzama).Szektorido(Szam) = KorokTomb(KorokSzama).Korido

                ' "j" seg�dv�ltoz� a ciklushoz.
                Dim j As Byte
                For j = LBound(KorokTomb(KorokSzama).Szektorido) To UBound(KorokTomb(KorokSzama).Szektorido) - 1
                    ' Az utols� szektorid�t �gy kapjuk meg hogy a m�sikakat kivonjuk bel�le.
                    KorokTomb(KorokSzama).Szektorido(Szam) = KorokTomb(KorokSzama).Szektorido(Szam) - KorokTomb(KorokSzama).Szektorido(j)
                Next j
            Else
                ' Szektorid� be�ll�t�sa.
                KorokTomb(KorokSzama).Szektorido(Szam) = DateDiff("s", EgySzektorido, NowTime)
            End If

            ' Akkor fut le ha az aut� szektorideje jobb mint a r�gi.
            If LegjobbSzektorido(Szam) > KorokTomb(KorokSzama).Szektorido(Szam) Then
                ' �j legjobb szektorid� be�ll�t�sa.
                LegjobbSzektorido(Szam) = KorokTomb(KorokSzama).Szektorido(Szam)
            End If

            ' Jelenlegi id� be�ll�t�sa.
            NowTime = Now

            ' Akkor fut le ha a harmadik c�lvonalon ment �t az aut�. Az az a c�lvonalon.
            If Szam = 3 Then
                'Jelenlegi id� be�ll�t�sa.
                EgyKorido = NowTime
            End If

            ' Jelenlegi id� be�ll�t�sa.
            EgySzektorido = NowTime
        ' Akkor fut le ha a t�vols�g nagyobb mint 100 �s �tment az aut� egy szektorvonalon.
        ElseIf dist > 100 And ASzektorvonal Then
            ' Szektorvonalon val� �tmen�s hamisra �ll�t�sa.
            ASzektorvonal = False
        End If
    Next ii

    ' Akkor fut le ha �j k�r j�n.
    If NextKor Then
        ' K�r�k sz�m�nak megn�vel�se eggyel.
        KorokSzama = KorokSzama + 1
    End If

    ' Akkor fut le ha a k�r�k sz�ma m�r nagyobb mint ami be lett �ll�tva a konfigban.
    If KorokSzama > Config.Globalis_KorokSzama Then
        ' Aut� j�t�k�t befejezetre �ll�tja.
        GameEnd = True
    End If
End Sub

' Timer0 id�zit� Timer esem�nye.
Private Sub Timer0_Timer()
    ' �rt�k n�vel�se egyyel.
    i = i + 1

    ' Akkor fut le ha a t�mbb elemeinek sz�m�n�l nagyobb az "i".
    If i > UBound(VSzogTomb) - LBound(VSzogTomb) + 1 Then
        ' "i" vissza�ll�t�sa az alap �rt�kre.
        i = LBound(VSzogTomb)

        Randomize
        ' �rt�k be�ll�t�sa. 50-71 millisec (V�letlen sz�m.)
        Timer0.Interval = Int(50 + Rnd * 21)
    End If

    ' Akkor fut le ha az aut� meg lett �ll�tva.
    If BStopKorido Then
        ' T�rolni fogja a jelenlegi id�t.
        Dim NowTime As Date
        ' Jelenlegi id� be�ll�t�sa.
        NowTime = Now
        ' Id�k k�z�tti k�l�nbs�g kisz�m�t�sa.
        EgyKorido = DateAdd("s", DateDiff("s", StopKorido, NowTime), EgyKorido)
        ' Id�k k�z�tti k�l�nbs�g kisz�m�t�sa.
        EgySzektorido = DateAdd("s", DateDiff("s", StopKorido, NowTime), EgySzektorido)
        ' �rt�k hamisra �ll�t�sa.
        BStopKorido = False
    End If

    ' Balra kanyarod�s v�letlen sz�ggel.
    NextCoordinate True, True

    ' T�rolja a baloldali volnal X koordin�t�j�t.
    Dim xb As Single
    ' T�rolja a baloldali volnal Y koordin�t�j�t.
    Dim yb As Single
    ' T�rolja a jobboldali volnal X koordin�t�j�t.
    Dim xj As Single
    ' T�rolja a jobboldali volnal Y koordin�t�j�t.
    Dim yj As Single

    ' Ide�lisan k�z�pen van �gy a j�rm�.
    If PontosabbKor Then
        ' XB be�ll�t�sa.
        xb = x0 + xhossz * ex - yhossz * ey
        ' YB be�ll�t�sa.
        yb = y0 + xhossz * ey + yhossz * ex
        ' XJ be�ll�t�sa.
        xj = x0 + xhossz * ex + yhossz * ey
        ' YJ be�ll�t�sa.
        yj = y0 + xhossz * ey - yhossz * ex
    Else
        ' XB be�ll�t�sa.
        xb = x0 + 400 * ex - 300 * ey
        ' YB be�ll�t�sa.
        yb = y0 + 400 * ey + 300 * ex
        ' XJ be�ll�t�sa.
        xj = x0 + 400 * ex + 300 * ey
        ' YJ be�ll�t�sa.
        yj = y0 + 400 * ey - 300 * ex
    End If

    ' Baloldali kocsivonalt�l m�rt t�vols�got t�rolja.
    Dim distb As Single
    ' Jobboldali kocsivonalt�l m�rt t�vols�got t�rolja.
    Dim distj As Single
    ' "ciklus" seg�dv�ltoz� a ciklushoz.
    Dim ciklus As Integer
    ' Kezd��rt�k be�ll�t�sa a t�vols�gnak.
    distb = KezdoTavolsagPontok
    ' Kezd��rt�k be�ll�t�sa a t�vols�gnak.
    distj = KezdoTavolsagPontok

    For ciklus = LBound(PalyaInfo.PalyaVonalTomb) To PalyaInfo.PalyaVonalakSzama - 1
        ' Baloldali kocsivonal t�vols�g�nak seg�dv�ltoz�ja.
        Dim db As Single
        ' Jobboldali kocsivonal t�vols�g�nak seg�dv�ltoz�ja.
        Dim dj As Single
        ' T�vols�g be�ll�t�sa.
        db = Distance(xb, yb, KorrigacioX(PalyaInfo.PalyaVonalTomb(ciklus).X1), KorrigacioX(PalyaInfo.PalyaVonalTomb(ciklus).X2), KorrigacioY(PalyaInfo.PalyaVonalTomb(ciklus).Y1), KorrigacioY(PalyaInfo.PalyaVonalTomb(ciklus).Y2))
        ' T�vols�g be�ll�t�sa.
        dj = Distance(xj, yj, KorrigacioX(PalyaInfo.PalyaVonalTomb(ciklus).X1), KorrigacioX(PalyaInfo.PalyaVonalTomb(ciklus).X2), KorrigacioY(PalyaInfo.PalyaVonalTomb(ciklus).Y1), KorrigacioY(PalyaInfo.PalyaVonalTomb(ciklus).Y2))

        ' A legkisebb t�vols�got keresi.
        If distb > db Then
             ' �rt�k be�ll�t�sa.
            distb = db
        End If

        ' A legkisebb t�vols�got keresi.
        If distj > dj Then
            ' �rt�k be�ll�t�sa.
            distj = dj
        End If
    Next ciklus

    ' Ide�lisan k�z�pen van �gy a j�rm�.
    If PontosabbKor Then
        ' Akkor fut le ha a baloldali �s jobboldali kocsivonal k�l�nbs�g�t�l m�rt t�vols�g kisebb mint 200 de nagyobb mint nulla.
        If distb - distj > 0 And distb - distj < 200 Then
            ' Jobbra fordul�s.
            NextCoordinate False, False
            ' Aut� vonalainak mozgat�sa a k�vetkez� koordin�t�kra.
            NextMove
        ' Akkor fut le ha a jobboldali �s baloldali kocsivonal k�l�nbs�g�t�l m�rt t�vols�g kisebb mint 200 de nagyobb mint nulla.
        ElseIf distj - distb > 0 And distj - distb < 200 Then
            ' Balra fordul�s.
            NextCoordinate True, False
            ' Aut� vonalainak mozgat�sa a k�vetkez� koordin�t�kra.
            NextMove
        End If
    Else
        ' Akkor fut le ha a baloldali kocsivonaltol m�rt t�vols�g kisebb mint 200.
        If distb < 200 Then
            ' Balra fordul�s.
            NextCoordinate True, False
            ' Aut� vonalainak mozgat�sa a k�vetkez� koordin�t�kra.
            NextMove
        ' Akkor fut le ha a baloldali kocsivonaltol m�rt t�vols�g nagyobb mint 200.
        ElseIf distb > 200 Then
            ' Jobbra fordul�s.
            NextCoordinate False, False
            ' Aut� vonalainak mozgat�sa a k�vetkez� koordin�t�kra.
            NextMove
        Else
            ' X0 be�ll�t�sa.
            x0 = x0 - 55 * ex
            ' Y0 be�ll�t�sa.
            y0 = y0 - 55 * ey
        End If
    End If

    ' Aut� vonalainak mozgat�sa a k�vetkez� koordin�t�kra.
    NextMove

    ' X0 be�ll�t�sa.
    x0 = x0 + 50 * ex
    ' Y0 be�ll�t�sa.
    y0 = y0 + 50 * ey
    ' Aut� vonalainak mozgat�sa a k�vetkez� koordin�t�kra.
    NextMove

    ' Szektorok elemz�se.
    Szektorok

    ' Nyomvonal bekapcsol�sa ha igaz az �rt�k.
    If Nyomvonal Then
        ' Nyomvonal kirajzol�sa.
        Palya.VirtualisPalya.Circle (x0, y0), 10, Color
    End If

    ' Akkor fut le ha az els� k�rben vagyunk.
    If KorokSzama = Palya.GetKezdokorErteke And IndulasStartVonalElol Then
        ' Egy k�r hossz�nak m�r�se.
        EgyKorHossza = EgyKorHossza + PalyaHosszanakLepteke
    End If

    ' �sszes megtett �t sz�m�t�sa.
    OsszesUt = OsszesUt + PalyaHosszanakLepteke

    ' Akkor fut le ha a kocsi c�lba�rt m�r.
    If GameEnd Then
        ' Utols� m�terek sz�mol�sa l�pt�kkel.
        UtolsoMeterek = UtolsoMeterek + 1

        ' Akkor fut le ha az utols� m�terek sz�ma el�rte a maximumot.
        If UtolsoMeterek = 20 Then
            ' Id�z�t� kikapcsol�sa.
            Timer0.Enabled = False
        End If
    End If
End Sub

' Elmozd�tja a koordin�t�kat a k�vetkez� pontra.
' A "BalraKanyarodas" azt t�rolja hogy az aut� balra vagy jobbra forduljon-e. Ha balra kell fordulni akkor igaz ha jobbra akkor hamis.
' A "VSzog" igazra �ll�t�s�val a v�letlen sz�geket haszn�lja fel az elj�r�s a t�mbb�l.
Private Sub NextCoordinate(ByVal BalraKanyarodas As Boolean, ByVal VSzog As Boolean)
    ' T�rolja a balra illetve a jobbra kanyarod�s m�rt�k�t.
    Dim bj As Double

    ' Akkor fut le ha igaz a v�ltoz�. Ebben az esetben balra kanyarodik az aut�.
    If BalraKanyarodas Then
        ' Balra kanyarod�s m�rt�ke.
        bj = -0.15
    Else
        ' Jobbra kanyarod�s m�rt�ke.
        bj = 0.15
    End If

    ' Ha igaz akkor a t�mbben t�rolt v�letlen sz�ggel fordul el.
    If VSzog Then
        ' X komponens.
        ex = Cos(VSzogTomb(i)) * ex - Sin(VSzogTomb(i)) * ey
        ' Y komponens.
        ey = Cos(VSzogTomb(i)) * ey + Sin(VSzogTomb(i)) * ex
    Else
        ' X komponens.
        ex = Cos(bj) * ex - Sin(bj) * ey
        ' Y komponens.
        ey = Cos(bj) * ey + Sin(bj) * ex
    End If

    ' X komponens m�rt�k�nek korrig�ci�ja.
    ex = ex / Sqr(ex * ex + ey * ey)
    ' Y komponens m�rt�k�nek korrig�ci�ja.
    ey = ey / Sqr(ex * ex + ey * ey)
End Sub

' Mozgat�s a k�vetkez� pontokba.
Private Sub NextMove()
    ' Vonal X1 pontj�nak legener�l�sa.
    KVonalTomb(1).X1 = x0 + xhossz * ex - yhossz * ey
    ' Vonal Y1 pontj�nak legener�l�sa.
    KVonalTomb(1).Y1 = y0 + xhossz * ey + yhossz * ex
    ' Vonal X2 pontj�nak legener�l�sa.
    KVonalTomb(1).X2 = x0 - xhossz * ex - yhossz * ey
    ' Vonal Y2 pontj�nak legener�l�sa.
    KVonalTomb(1).Y2 = y0 - xhossz * ey + yhossz * ex

    ' Vonal X1 pontj�nak legener�l�sa.
    KVonalTomb(2).X1 = x0 + xhossz * ex + yhossz * ey
    ' Vonal Y1 pontj�nak legener�l�sa.
    KVonalTomb(2).Y1 = y0 + xhossz * ey - yhossz * ex
    ' Vonal X2 pontj�nak legener�l�sa.
    KVonalTomb(2).X2 = x0 - xhossz * ex + yhossz * ey
    ' Vonal Y2 pontj�nak legener�l�sa.
    KVonalTomb(2).Y2 = y0 - xhossz * ey - yhossz * ex

    ' Vonal X1 pontj�nak legener�l�sa.
    KVonalTomb(3).X1 = KVonalTomb(1).X1
    ' Vonal X2 pontj�nak legener�l�sa.
    KVonalTomb(3).X2 = KVonalTomb(2).X1
    ' Vonal Y1 pontj�nak legener�l�sa.
    KVonalTomb(3).Y1 = KVonalTomb(1).Y1
    ' Vonal Y2 pontj�nak legener�l�sa.
    KVonalTomb(3).Y2 = KVonalTomb(2).Y1

    ' Vonal X1 pontj�nak legener�l�sa.
    KVonalTomb(4).X1 = KVonalTomb(1).X2
    ' Vonal X2 pontj�nak legener�l�sa.
    KVonalTomb(4).X2 = KVonalTomb(2).X2
    ' Vonal Y1 pontj�nak legener�l�sa.
    KVonalTomb(4).Y1 = KVonalTomb(1).Y2
    ' Vonal Y2 pontj�nak legener�l�sa.
    KVonalTomb(4).Y2 = KVonalTomb(2).Y2
End Sub
