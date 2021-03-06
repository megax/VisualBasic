VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "Map"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
' Fejl�c
' K�sz�tette: Moln�r P�ter
' Fejl�c v�ge

Option Explicit

' P�lya el�r�si �tvonal�t t�rolja.
Private MapPath As String

' Be�ll�tjuk a form l�trehoz�sakor az alap folyamatokat.
Private Sub Class_Initialize()
    ' Be�ll�tja az el�r�si �tvonalat.
    MapPath = MapDir & "/" & Config.Globalis_PalyaNeve
End Sub

' P�lya bet�lt�se.
' A "MapName" t�rolja a p�lya f�jl�nak nev�t.
Public Sub LoadMap(ByVal MapName As String)
    ' Kitakar�tja a v�ltoz�kat.
    Clean

    ' Megn�zzi l�tezik-e a p�lya mapp�ja. Ha nem akkor l�trehozza.
    If DirExists(MapDir) Then
        ' P�lya mappa l�trehoz�sa.
        MkDir MapDir
    End If

    ' Be�ll�tja az el�r�si �tvonalat.
    MapPath = MapDir & "/" & MapName

    ' Megn�zzi l�tezik-e a p�lya f�jl.
    If FileExists(MapPath) Then
    ' Ha �j p�lya f�jl lenne l�trehozva akkor is elfut ez a r�sz hogy bet�lt�djenek a be�ll�t�sok.
UjBetoltese:
        ' F�jl megny�t�sa olvas�sra.
        Open MapPath For Input As #1

        ' Addig fog futni am�g nem �r a konfig f�jl v�g�re.
        Do Until EOF(1)
            ' A program soronk�nt fogja az adatokat bet�lteni �gy a v�ltoz� a sorok adat�t fogja t�rolni.
            Dim Sor As String
            ' Adatok bet�lt�se soronk�nt.
            Line Input #1, Sor

            ' Csak akkor fut le ha van valami sz�veg az adott sorban.
            If Len(Trim(Sor)) > 0 Then
                ' Kisz�ri a kommenteket ezzel a felt�telel. �gy csak akkor fut le ha nem kommentes sor.
                If Not Mid$(Sor, 1, 1) = "#" Then
                    ' Akkor fut le ha l�tezik az adott be�ll�t�s.
                    If InStr(Sor, "PalyaVonal") > 0 Then
                        ' Ha nagyobb a p�lya vonalak sz�ma mint amit a t�mb t�rolni tud akkor fut le.
                        If PalyaInfo.PalyaVonalakSzama >= UBound(PalyaInfo.PalyaVonalTomb) Then
                            ' T�mb megn�vel�se.
                            ReDim Preserve PalyaInfo.PalyaVonalTomb(0 To UBound(PalyaInfo.PalyaVonalTomb) + 50) As VonalKoordinatak
                        End If

                        ' Be�ll�t�s bet�lt�se.
                        PalyaInfo.PalyaVonalTomb(PalyaInfo.PalyaVonalakSzama) = ParseLine(Parse(Sor))
                        ' Vonal l�trehoz�sa.
                        Set PalyaInfo.PalyaVonalTomb(PalyaInfo.PalyaVonalakSzama).Vonal = Palya.Controls.Add("VB.Line", "PalyaVonal" & CStr(PalyaInfo.PalyaVonalakSzama), Palya)
                        'PalyaInfo.PalyaVonalTomb(PalyaInfo.PalyaVonalakSzama).Vonal.BorderColor = &H80000008
                        ' X1 pont be�ll�t�sa.
                        PalyaInfo.PalyaVonalTomb(PalyaInfo.PalyaVonalakSzama).Vonal.X1 = PalyaInfo.PalyaVonalTomb(PalyaInfo.PalyaVonalakSzama).X1
                        ' X2 pont be�ll�t�sa.
                        PalyaInfo.PalyaVonalTomb(PalyaInfo.PalyaVonalakSzama).Vonal.X2 = PalyaInfo.PalyaVonalTomb(PalyaInfo.PalyaVonalakSzama).X2
                        ' Y1 pont be�ll�t�sa.
                        PalyaInfo.PalyaVonalTomb(PalyaInfo.PalyaVonalakSzama).Vonal.Y1 = PalyaInfo.PalyaVonalTomb(PalyaInfo.PalyaVonalakSzama).Y1
                        ' Y2 pont be�ll�t�sa.
                        PalyaInfo.PalyaVonalTomb(PalyaInfo.PalyaVonalakSzama).Vonal.Y2 = PalyaInfo.PalyaVonalTomb(PalyaInfo.PalyaVonalakSzama).Y2
                        ' Vonal sz�less�g�nek be�ll�t�sa.
                        PalyaInfo.PalyaVonalTomb(PalyaInfo.PalyaVonalakSzama).Vonal.BorderWidth = 2
                        ' Vonal l�that�v� t�tele.
                        PalyaInfo.PalyaVonalTomb(PalyaInfo.PalyaVonalakSzama).Vonal.Visible = True
                        ' �rt�k megn�vel�se eggyel.
                        PalyaInfo.PalyaVonalakSzama = PalyaInfo.PalyaVonalakSzama + 1
                    End If

                    ' Akkor fut le ha l�tezik az adott be�ll�t�s.
                    If InStr(Sor, "SzektorVonal") > 0 Then
                        ' Ha nagyobb a szektor vonalak sz�ma mint amit a t�mb t�rolni tud akkor fut le.
                        If PalyaInfo.SzektorVonalakSzama >= UBound(PalyaInfo.SzektorVonalTomb) Then
                            ' T�mb megn�vel�se.
                            ReDim Preserve PalyaInfo.SzektorVonalTomb(0 To UBound(PalyaInfo.SzektorVonalTomb) + 5) As VonalKoordinatak
                        End If

                        ' Be�ll�t�s bet�lt�se.
                        PalyaInfo.SzektorVonalTomb(PalyaInfo.SzektorVonalakSzama) = ParseLine(Parse(Sor))
                        ' Vonal l�trehoz�sa.
                        Set PalyaInfo.SzektorVonalTomb(PalyaInfo.SzektorVonalakSzama).Vonal = Palya.Controls.Add("VB.Line", "SzektorVonal" & CStr(PalyaInfo.SzektorVonalakSzama), Palya)
                        'PalyaInfo.SzektorVonalTomb(PalyaInfo.SzektorVonalakSzama).Vonal.BorderColor = &H80000008
                        ' X1 pont be�ll�t�sa.
                        PalyaInfo.SzektorVonalTomb(PalyaInfo.SzektorVonalakSzama).Vonal.X1 = PalyaInfo.SzektorVonalTomb(PalyaInfo.SzektorVonalakSzama).X1
                        ' X2 pont be�ll�t�sa.
                        PalyaInfo.SzektorVonalTomb(PalyaInfo.SzektorVonalakSzama).Vonal.X2 = PalyaInfo.SzektorVonalTomb(PalyaInfo.SzektorVonalakSzama).X2
                        ' Y1 pont be�ll�t�sa.
                        PalyaInfo.SzektorVonalTomb(PalyaInfo.SzektorVonalakSzama).Vonal.Y1 = PalyaInfo.SzektorVonalTomb(PalyaInfo.SzektorVonalakSzama).Y1
                        ' Y2 pont be�ll�t�sa.
                        PalyaInfo.SzektorVonalTomb(PalyaInfo.SzektorVonalakSzama).Vonal.Y2 = PalyaInfo.SzektorVonalTomb(PalyaInfo.SzektorVonalakSzama).Y2
                        ' Vonal sz�less�g�nek be�ll�t�sa.
                        PalyaInfo.SzektorVonalTomb(PalyaInfo.SzektorVonalakSzama).Vonal.BorderWidth = 1
                        ' Vonal l�that�v� t�tele.
                        PalyaInfo.SzektorVonalTomb(PalyaInfo.SzektorVonalakSzama).Vonal.Visible = True
                        ' �rt�k megn�vel�se eggyel.
                        PalyaInfo.SzektorVonalakSzama = PalyaInfo.SzektorVonalakSzama + 1
                    End If

                    ' Akkor fut le ha l�tezik az adott be�ll�t�s.
                    If InStr(Sor, "SzektorNev") > 0 Then
                        ' Ha nagyobb a szektor neveinek sz�ma mint amit a t�mb t�rolni tud akkor fut le.
                        If PalyaInfo.SzektorNevekSzama >= UBound(PalyaInfo.SzektorNevTomb) Then
                            ' T�mb megn�vel�se.
                            ReDim Preserve PalyaInfo.SzektorNevTomb(0 To UBound(PalyaInfo.SzektorNevTomb) + 5) As NevKoordinatak
                        End If

                        ' Be�ll�t�s bet�lt�se.
                        PalyaInfo.SzektorNevTomb(PalyaInfo.SzektorNevekSzama) = ParseLabel(Parse(Sor))
                        ' "Label" l�trehoz�sa.
                        Set PalyaInfo.SzektorNevTomb(PalyaInfo.SzektorNevekSzama).Label = Palya.Controls.Add("VB.Label", "SzektorNev" & CStr(PalyaInfo.SzektorNevekSzama), Palya)
                        ' "Label" h�tt�rszin�nek be�ll�t�sa a p�ly�hoz.
                        PalyaInfo.SzektorNevTomb(PalyaInfo.SzektorNevekSzama).Label.BackColor = Palya.BackColor
                        ' "Label" m�ret�nek automatikus v�ltoztat�s�nak bekapcsol�sa.
                        PalyaInfo.SzektorNevTomb(PalyaInfo.SzektorNevekSzama).Label.AutoSize = True
                        ' "Label" sz�veg�nek be�ll�t�sa.
                        PalyaInfo.SzektorNevTomb(PalyaInfo.SzektorNevekSzama).Label.Caption = "Szektor " & CStr(PalyaInfo.SzektorNevekSzama + 1)
                        ' "Left" pozici� be�ll�t�sa.
                        PalyaInfo.SzektorNevTomb(PalyaInfo.SzektorNevekSzama).Label.Left = PalyaInfo.SzektorNevTomb(PalyaInfo.SzektorNevekSzama).Left
                        ' "Top" pozici� be�ll�t�sa.
                        PalyaInfo.SzektorNevTomb(PalyaInfo.SzektorNevekSzama).Label.Top = PalyaInfo.SzektorNevTomb(PalyaInfo.SzektorNevekSzama).Top
                        ' "Label" l�that�v� t�tele.
                        PalyaInfo.SzektorNevTomb(PalyaInfo.SzektorNevekSzama).Label.Visible = True
                        ' �rt�k megn�vel�se eggyel.
                        PalyaInfo.SzektorNevekSzama = PalyaInfo.SzektorNevekSzama + 1
                    End If

                    ' Akkor fut le ha l�tezik az adott be�ll�t�s.
                    If InStr(Sor, "StartCelVonalNev") > 0 Then
                        ' Be�ll�t�s bet�lt�se.
                        PalyaInfo.StartCelVonalNev = ParseLabel(Parse(Sor))
                        Set PalyaInfo.StartCelVonalNev.Label = Palya.Controls.Add("VB.Label", "StartCelVonalNev", Palya)
                        ' "Label" h�tt�rszin�nek be�ll�t�sa a p�ly�hoz.
                        PalyaInfo.StartCelVonalNev.Label.BackColor = Palya.BackColor
                        ' "Label" m�ret�nek automatikus v�ltoztat�s�nak bekapcsol�sa.
                        PalyaInfo.StartCelVonalNev.Label.AutoSize = True
                        ' "Label" sz�veg�nek be�ll�t�sa.
                        PalyaInfo.StartCelVonalNev.Label.Caption = "Start / C�l"
                        ' "Left" pozici� be�ll�t�sa.
                        PalyaInfo.StartCelVonalNev.Label.Left = PalyaInfo.StartCelVonalNev.Left
                        ' "Top" pozici� be�ll�t�sa.
                        PalyaInfo.StartCelVonalNev.Label.Top = PalyaInfo.StartCelVonalNev.Top
                        ' "Label" l�that�v� t�tele.
                        PalyaInfo.StartCelVonalNev.Label.Visible = True
                    End If

                    ' Akkor fut le ha l�tezik az adott be�ll�t�s.
                    If InStr(Sor, "KorokSzama") > 0 Then
                        ' Megvizsg�lja hogy "byte"-e az adat.
                        If IsByte(Parse(Sor)) Then
                            ' Be�ll�t�s bet�lt�se.
                            PalyaInfo.KorokSzama = CByte(Parse(Sor))
                        Else
                            ' Alap�rtelmezett be�ll�t�s bet�lt�se.
                            PalyaInfo.KorokSzama = AGlobalis_KorokSzama
                        End If

                        ' Ha nagyobb a k�r�k sz�ma mint a maxim�lis vagy a minim�lisn�l kisebb akkor az alap�rtelmezetett t�lti be.
                        If PalyaInfo.KorokSzama > 20 Or PalyaInfo.KorokSzama < 2 Then
                            ' Alap�rtelmezett be�ll�t�s bet�lt�se.
                            PalyaInfo.KorokSzama = AGlobalis_KorokSzama
                        End If
                    End If

                    ' Akkor fut le ha l�tezik az adott be�ll�t�s.
                    If InStr(Sor, "KocsiVonal") > 0 Then
                        ' Ha nagyobb a kocsi vonalak sz�ma mint amit a t�mb t�rolni tud akkor fut le.
                        If PalyaInfo.KocsiVonalakSzama >= UBound(PalyaInfo.SzektorVonalTomb) Then
                            ' T�mb megn�vel�se.
                            ReDim Preserve PalyaInfo.KocsiVonalTomb(1 To UBound(PalyaInfo.KocsiVonalTomb) + 4) As VonalKoordinatak
                        End If

                        ' Be�ll�t�s bet�lt�se.
                        PalyaInfo.KocsiVonalTomb(PalyaInfo.KocsiVonalakSzama) = ParseLine(Parse(Sor))
                        ' �rt�k megn�vel�se eggyel.
                        PalyaInfo.KocsiVonalakSzama = PalyaInfo.KocsiVonalakSzama + 1
                    End If
                End If
            End If
        Loop

        ' F�jl lez�s�ra.
        Close #1
    Else
        ' Be�ll�tja az el�r�si �tvonalat.
        MapPath = MapDir & "/" & AGlobalis_PalyaNeve

        ' Ha nem l�tezik az alap�rtelmezett p�lya akkor l�trehozza.
        If Not FileExists(MapPath) Then
            ' P�lya l�trehoz�sa.
            CreateMap
        End If

        ' P�lya be�ll�t�sok bet�lt�se.
        GoTo UjBetoltese
    End If
End Sub

' Alap�rtelmezett p�lya t�rl�se.
Public Sub DeleteDefaultMap()
    ' Be�ll�tja az el�r�si �tvonalat.
    MapPath = MapDir & "/" & AGlobalis_PalyaNeve

    ' Megn�zi l�tezik-e az alap�rtelmezett p�lya. Ha igen akkor t�rli.
    If FileExists(MapPath) Then
        ' P�lya f�jl t�rl�se.
        Kill MapPath
    End If
End Sub

' P�lya f�jl l�trehoz�sa.
Private Sub CreateMap()
    ' F�jl megny�t�sa �r�sra.
    Open MapPath For Output As #1

    ' Adatok ki�r�sa a f�jlba.
    Print #1, "# Alap�rtelmezett map."
    Print #1, ""
    Print #1, "# P�ly�hoz tartoz� k�r�k sz�ma. Maximum: 20, Minimum: 2"
    Print #1, "KorokSzama: 5"
    Print #1, ""
    Print #1, "# Start �s c�lvonal neve."
    Print #1, "StartCelVonalNev: 1680;4440"
    Print #1, ""
    Print #1, "# Szektorok neve."
    Print #1, "SzektorNev: 4680;360"
    Print #1, "SzektorNev: 6600;5640"
    Print #1, "SzektorNev: 0;4440"
    Print #1, ""
    Print #1, "# Szektor vonalak."
    Print #1, "SzektorVonal: 4560;3600;360;2280"
    Print #1, "SzektorVonal: 6480;5040;5880;4920"
    Print #1, "SzektorVonal: 1920;600;4680;4680"
    Print #1, ""
    Print #1, "# Kocsi vonalak."
    Print #1, "KocsiVonal: 1100;0;5000;0"
    Print #1, "KocsiVonal: 900;0;5000;0"
    Print #1, "KocsiVonal: 900;0;5300;0"
    Print #1, "KocsiVonal: 1100;0;5300;0"
    Print #1, ""
    Print #1, "# P�lya vonalak."
    Print #1, "PalyaVonal: 720;720;3720;4320"
    Print #1, "PalyaVonal: 960;720;3120;3720"
    Print #1, "PalyaVonal: 5040;4200;5640;6240"
    Print #1, "PalyaVonal: 4200;3360;6240;6480"
    Print #1, "PalyaVonal: 2880;2040;7080;6720"
    Print #1, "PalyaVonal: 2040;720;6720;5520"
    Print #1, "PalyaVonal: 5400;4680;6720;6960"
    Print #1, "PalyaVonal: 5760;5400;6000;6720"
    Print #1, "PalyaVonal: 4680;3720;6960;7200"
    Print #1, "PalyaVonal: 2280;3360;6000;6480"
    Print #1, "PalyaVonal: 1560;2280;5400;6000"
    Print #1, "PalyaVonal: 3720;2880;7200;7080"
    Print #1, "PalyaVonal: 5760;5400;4200;4920"
    Print #1, "PalyaVonal: 5400;5040;4920;5640"
    Print #1, "PalyaVonal: 6960;5760;4320;4200"
    Print #1, "PalyaVonal: 7200;6120;4920;5280"
    Print #1, "PalyaVonal: 6120;5760;5280;6000"
    Print #1, "PalyaVonal: 7680;6960;3720;4320"
    Print #1, "PalyaVonal: 8040;7200;4560;4920"
    Print #1, "PalyaVonal: 8400;8040;3840;4560"
    Print #1, "PalyaVonal: 8400;8400;3240;3840"
    Print #1, "PalyaVonal: 7680;7680;3120;3720"
    Print #1, "PalyaVonal: 7680;4560;3120;1920"
    Print #1, "PalyaVonal: 8400;4200;2640;840"
    Print #1, "PalyaVonal: 4560;3720;1920;1560"
    Print #1, "PalyaVonal: 4200;3360;840;960"
    Print #1, "PalyaVonal: 3720;3360;1560;1800"
    Print #1, "PalyaVonal: 3360;3240;1800;1920"
    Print #1, "PalyaVonal: 3240;3000;1920;2520"
    Print #1, "PalyaVonal: 2400;1800;3120;3240"
    Print #1, "PalyaVonal: 1800;1560;3240;3600"
    Print #1, "PalyaVonal: 1560;1560;4800;5400"
    Print #1, "PalyaVonal: 1560;1560;3600;4200"
    Print #1, "PalyaVonal: 3000;2400;2520;3120"
    Print #1, "PalyaVonal: 2040;1440;2520;2640"
    Print #1, "PalyaVonal: 2640;2400;1680;2280"
    Print #1, "PalyaVonal: 2400;2040;2280;2520"
    Print #1, "PalyaVonal: 3360;2880;960;1200"
    Print #1, "PalyaVonal: 8400;8400;2640;3240"
    Print #1, "PalyaVonal: 1440;960;2640;3120"
    Print #1, "PalyaVonal: 1560;1560;4200;4800"
    Print #1, "PalyaVonal: 2880;2640;1200;1680"
    Print #1, "PalyaVonal: 720;720;4320;4920"
    Print #1, "PalyaVonal: 720;720;4920;5520"

    ' F�jl lez�s�ra.
    Close #1
End Sub

' Sz�tv�gja a bet�lt�tt sorokat. Majd visszadja az �rt�kes adatokat.
' A "Sor" v�ltoz� a p�lya f�jl egy sor�t tartalmazza ami �ppen kiolvas�sra ker�lt.
Private Function Parse(ByVal Sor As String) As String
    ' Kett�spont jel ut�ni r�szt adja vissza. A felesleges adatokat elt�vol�tja (pl: sz�k�z).
    Parse = LTrim(Mid$(Sor, InStr(1, Sor, ":") + 1))
End Function

' Sz�tv�gja a bet�lt�tt sorokat. Majd visszadja az �rt�kes adatokat.
' A "Sor" v�ltoz� a p�lya f�jl egy sor�t tartalmazza ami �ppen kiolvas�sra ker�lt.
Private Function ParseLine(ByVal Sor As String) As VonalKoordinatak
    ' V�ltoz� l�trehoz�sa.
    Dim vk As VonalKoordinatak
    ' �res t�mb l�trehoz�sa.
    Dim v() As String

    ' Darabolja a sort kett�spont alapj�n.
    v = Split(Sor, ";")

    ' Akkor fut le ha nincs annyi eleme a t�mbnek mint amennyi a hib�tlan lefut�shoz kell.
    If UBound(v) - LBound(v) + 1 < 4 Then
        ' Kil�p�s a f�ggv�nyb�l.
        Exit Function
    End If

    ' Megn�zi hogy a v�ltoz� "integer"-e.
    If IsInteger(v(0)) Then
        ' �rt�k �tad�sa.
        vk.X1 = v(0)
    Else
        ' Null�ra �ll�t�s.
        vk.X1 = 0
    End If

    ' Megn�zi hogy a v�ltoz� "integer"-e.
    If IsInteger(v(1)) Then
        ' �rt�k �tad�sa.
        vk.X2 = v(1)
    Else
        ' Null�ra �ll�t�s.
        vk.X2 = 0
    End If

    ' Megn�zi hogy a v�ltoz� "integer"-e.
    If IsInteger(v(2)) Then
        ' �rt�k �tad�sa.
        vk.Y1 = v(2)
    Else
        ' Null�ra �ll�t�s.
        vk.Y1 = 0
    End If

    ' Megn�zi hogy a v�ltoz� "integer"-e.
    If IsInteger(v(3)) Then
        ' �rt�k �tad�sa.
        vk.Y2 = v(3)
    Else
        ' Null�ra �ll�t�s.
        vk.Y2 = 0
    End If

    ' Be�ll�tott adatok visszad�sa.
    ParseLine = vk
End Function

' Sz�tv�gja a bet�lt�tt sorokat. Majd visszadja az �rt�kes adatokat.
' A "Sor" v�ltoz� a p�lya f�jl egy sor�t tartalmazza ami �ppen kiolvas�sra ker�lt.
Private Function ParseLabel(ByVal Sor As String) As NevKoordinatak
    ' V�ltoz� l�trehoz�sa.
    Dim nk As NevKoordinatak
    ' �res t�mb l�trehoz�sa.
    Dim v() As String

    ' Darabolja a sort kett�spont alapj�n.
    v = Split(Sor, ";")

    ' Akkor fut le ha nincs annyi eleme a t�mbnek mint amennyi a hib�tlan lefut�shoz kell.
    If UBound(v) - LBound(v) + 1 < 2 Then
        ' Kil�p�s a f�ggv�nyb�l.
        Exit Function
    End If

    ' Megn�zi hogy a v�ltoz� "integer"-e.
    If IsInteger(v(0)) Then
        ' �rt�k �tad�sa.
        nk.Left = v(0)
    Else
        ' Null�ra �ll�t�s.
        nk.Left = 0
    End If

    ' Megn�zi hogy a v�ltoz� "integer"-e.
    If IsInteger(v(1)) Then
        ' �rt�k �tad�sa.
        nk.Top = v(1)
    Else
        ' Null�ra �ll�t�s.
        nk.Top = 0
    End If

    ' Be�ll�tott adatok visszad�sa.
    ParseLabel = nk
End Function

' Kitakar�tja a v�ltoz�kat.
Private Sub Clean()
    ' "i" seg�dv�ltoz� a ciklushoz.
    Dim i As Integer

    ' Ha nagyobb mint nulla akkor fut le.
    If PalyaInfo.PalyaVonalakSzama > 0 Then
        For i = LBound(PalyaInfo.PalyaVonalTomb) To PalyaInfo.PalyaVonalakSzama - 1
            ' P�ly�r�l elt�vol�tja a vonalat.
            Palya.Controls.Remove PalyaInfo.PalyaVonalTomb(i).Vonal
            ' Null�z�s.
            Set PalyaInfo.PalyaVonalTomb(i).Vonal = Nothing
        Next i
    End If

    ' Ha nagyobb mint nulla akkor fut le.
    If PalyaInfo.SzektorVonalakSzama > 0 Then
        For i = LBound(PalyaInfo.SzektorVonalTomb) To PalyaInfo.SzektorVonalakSzama - 1
            ' P�ly�r�l elt�vol�tja a vonalat.
            Palya.Controls.Remove PalyaInfo.SzektorVonalTomb(i).Vonal
            ' Null�z�s.
            Set PalyaInfo.SzektorVonalTomb(i).Vonal = Nothing
        Next i
    End If

    ' Ha nagyobb mint nulla akkor fut le.
    If PalyaInfo.SzektorNevekSzama > 0 Then
        For i = LBound(PalyaInfo.SzektorNevTomb) To PalyaInfo.SzektorNevekSzama - 1
            ' P�ly�r�l elt�vol�tja a "Label"-t.
            Palya.Controls.Remove PalyaInfo.SzektorNevTomb(i).Label
            ' Null�z�s.
            Set PalyaInfo.SzektorNevTomb(i).Label = Nothing
        Next i
    End If

    ' Ha nem nulla akkor fut le.
    If Not PalyaInfo.StartCelVonalNev.Label Is Nothing Then
        ' P�ly�r�l elt�vol�tja a "Label"-t.
        Palya.Controls.Remove PalyaInfo.StartCelVonalNev.Label
        ' Null�z�s.
        Set PalyaInfo.StartCelVonalNev.Label = Nothing
    End If

    ' T�mb t�rl�se.
    ReDim PalyaInfo.PalyaVonalTomb(0 To 50) As VonalKoordinatak
    ' T�mb t�rl�se.
    ReDim PalyaInfo.SzektorVonalTomb(0 To 3) As VonalKoordinatak
    ' T�mb t�rl�se.
    ReDim PalyaInfo.KocsiVonalTomb(1 To 4) As VonalKoordinatak
    ' T�mb t�rl�se.
    ReDim PalyaInfo.SzektorNevTomb(0 To 3) As NevKoordinatak

    ' P�lya vonalak sz�m�t null�ra �ll�tja.
    PalyaInfo.PalyaVonalakSzama = 0
    ' Szektor vonalak sz�m�t null�ra �ll�tja.
    PalyaInfo.SzektorVonalakSzama = 0
    ' Kocsi vonalak sz�m�t null�ra �ll�tja.
    PalyaInfo.KocsiVonalakSzama = 1
    ' Szektor nevek sz�m�t null�ra �ll�tja.
    PalyaInfo.SzektorNevekSzama = 0
End Sub
