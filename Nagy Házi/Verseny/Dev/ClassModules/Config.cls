VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "Config"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
' Fejl�c
' K�sz�tette: Moln�r P�ter
' Fejl�c v�ge

Option Explicit

' Konfig mappa nev�t t�rolja.
Private Const ConfigDir = "Config"
' A konfig f�jl nev�t t�rolja.
Private Const ConfigFile = "Config.conf"
' A konfig f�jl el�r�si �tvonal�t t�rolja.
Private ConfigPath As String

' Glob�lis v�ltoz�. A neve takarja mira val�.
Public Globalis_Nyomvonal As Boolean
' Glob�lis v�ltoz�. A neve takarja mira val�.
Public Globalis_SzektorNevek As Boolean
' Glob�lis v�ltoz�. A neve takarja mira val�.
Public Globalis_StartCelVonalNeve As Boolean
' Glob�lis v�ltoz�. A neve takarja mira val�.
Public Globalis_KorokSzama As Byte
' Glob�lis v�ltoz�. A neve takarja mira val�.
Public Globalis_PalyaNeve As String
' Glob�lis v�ltoz�. A neve takarja mira val�.
Public Globalis_SzektorVonalak As Boolean
' Glob�lis v�ltoz�. A neve takarja mira val�.
Public Globalis_StartCelVonal As Boolean
' Glob�lis v�ltoz�. A neve takarja mira val�.
Public Globalis_TokeletesKorozes As Boolean
' Glob�lis v�ltoz�. A neve takarja mira val�.
Public Autok_Elso_Nyomvonal As Boolean
' Glob�lis v�ltoz�. A neve takarja mira val�.
Public Autok_Elso_TokeletesKorozes As Boolean
' Glob�lis v�ltoz�. A neve takarja mira val�.
Public Autok_Masodik_Nyomvonal As Boolean
' Glob�lis v�ltoz�. A neve takarja mira val�.
Public Autok_Masodik_TokeletesKorozes As Boolean
' Glob�lis v�ltoz�. A neve takarja mira val�.
Public Autok_Harmadik_Nyomvonal As Boolean
' Glob�lis v�ltoz�. A neve takarja mira val�.
Public Autok_Harmadik_TokeletesKorozes As Boolean
' Glob�lis v�ltoz�. A neve takarja mira val�.
Public Autok_Negyedik_Nyomvonal As Boolean
' Glob�lis v�ltoz�. A neve takarja mira val�.
Public Autok_Negyedik_TokeletesKorozes As Boolean

' Be�ll�tjuk a form l�trehoz�sakor az alap folyamatokat.
Private Sub Class_Initialize()
    ' Be�ll�tja az el�r�si �tvonalat.
    ConfigPath = ConfigDir & "/" & ConfigFile
End Sub

' Konfig f�jl bet�lt�se.
Public Sub LoadConfig()
    ' Megn�zzi l�tezik-e a konfig mapp�ja. Ha nem akkor l�trehozza.
    If DirExists(ConfigDir) Then
        ' Konfig mappa l�trehoz�sa.
        MkDir ConfigDir
    End If

    ' Megn�zzi l�tezik-e a konfig f�jl.
    If FileExists(ConfigPath) Then
    ' Ha �j konfig f�jl lenne l�trehozva akkor is elfut ez a r�sz hogy bet�lt�djenek a be�ll�t�sok.
UjKonfigBetoltese:
        ' Konfig adatok alap�rtelmez�sre �ll�t�sa.
        SetDefault
        ' F�jl megny�t�sa olvas�sra.
        Open ConfigPath For Input As #1

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
                    If InStr(Sor, "Globalis_Nyomvonal") > 0 Then
                        ' Megvizsg�lja hogy "boolean"-e az adat.
                        If IsBoolean(Parse(Sor)) Then
                            ' Be�ll�t�s bet�lt�se.
                            Globalis_Nyomvonal = CBool(Parse(Sor))
                        Else
                            ' Alap�rtelmezett be�ll�t�s bet�lt�se.
                            Globalis_Nyomvonal = AGlobalis_Nyomvonal
                        End If
                    End If

                    ' Akkor fut le ha l�tezik az adott be�ll�t�s.
                    If InStr(Sor, "Globalis_SzektorNevek") > 0 Then
                        ' Megvizsg�lja hogy "boolean"-e az adat.
                        If IsBoolean(Parse(Sor)) Then
                            ' Be�ll�t�s bet�lt�se.
                            Globalis_SzektorNevek = CBool(Parse(Sor))
                        Else
                            ' Alap�rtelmezett be�ll�t�s bet�lt�se.
                            Globalis_SzektorNevek = AGlobalis_SzektorNevek
                        End If
                    End If

                    ' Akkor fut le ha l�tezik az adott be�ll�t�s.
                    If InStr(Sor, "Globalis_StartCelVonalNeve") > 0 Then
                        ' Megvizsg�lja hogy "boolean"-e az adat.
                        If IsBoolean(Parse(Sor)) Then
                            ' Be�ll�t�s bet�lt�se.
                            Globalis_StartCelVonalNeve = CBool(Parse(Sor))
                        Else
                            ' Alap�rtelmezett be�ll�t�s bet�lt�se.
                            Globalis_StartCelVonalNeve = AGlobalis_StartCelVonalNeve
                        End If
                    End If

                    ' Akkor fut le ha l�tezik az adott be�ll�t�s.
                    If InStr(Sor, "Globalis_KorokSzama") > 0 Then
                        ' Megvizsg�lja hogy "byte"-e az adat.
                        If IsByte(Parse(Sor)) Then
                            ' Be�ll�t�s bet�lt�se.
                            Globalis_KorokSzama = CByte(Parse(Sor))
                        Else
                            ' Alap�rtelmezett be�ll�t�s bet�lt�se.
                            Globalis_KorokSzama = AGlobalis_KorokSzama
                        End If

                        ' Ha nagyobb a k�r�k sz�ma mint a maxim�lis vagy a minim�lisn�l kisebb akkor az alap�rtelmezetett t�lti be.
                        If Globalis_KorokSzama > 20 Or Globalis_KorokSzama < 2 Then
                            ' Alap�rtelmezett be�ll�t�s bet�lt�se.
                            Globalis_KorokSzama = AGlobalis_KorokSzama
                        End If
                    End If

                    ' Akkor fut le ha l�tezik az adott be�ll�t�s.
                    If InStr(Sor, "Globalis_PalyaNeve") > 0 Then
                        ' Be�ll�t�s bet�lt�se.
                        Globalis_PalyaNeve = CStr(Parse(Sor))
                    End If

                    ' Akkor fut le ha l�tezik az adott be�ll�t�s.
                    If InStr(Sor, "Globalis_SzektorVonalak") > 0 Then
                        ' Megvizsg�lja hogy "boolean"-e az adat.
                        If IsBoolean(Parse(Sor)) Then
                            ' Be�ll�t�s bet�lt�se.
                            Globalis_SzektorVonalak = CBool(Parse(Sor))
                        Else
                            ' Alap�rtelmezett be�ll�t�s bet�lt�se.
                            Globalis_SzektorVonalak = AGlobalis_SzektorVonalak
                        End If
                    End If

                    ' Akkor fut le ha l�tezik az adott be�ll�t�s.
                    If InStr(Sor, "Globalis_SCV") > 0 Then
                        ' Megvizsg�lja hogy "boolean"-e az adat.
                        If IsBoolean(Parse(Sor)) Then
                            ' Be�ll�t�s bet�lt�se.
                            Globalis_StartCelVonal = CBool(Parse(Sor))
                        Else
                            ' Alap�rtelmezett be�ll�t�s bet�lt�se.
                            Globalis_StartCelVonal = AGlobalis_StartCelVonal
                        End If
                    End If

                    ' Akkor fut le ha l�tezik az adott be�ll�t�s.
                    If InStr(Sor, "Globalis_TokeletesKorozes") > 0 Then
                        ' Megvizsg�lja hogy "boolean"-e az adat.
                        If IsBoolean(Parse(Sor)) Then
                            ' Be�ll�t�s bet�lt�se.
                            ' Globalis_TokeletesKorozes = CBool(Parse(Sor)) ' Kikapcsolva!!!
                        Else
                            ' Alap�rtelmezett be�ll�t�s bet�lt�se.
                            Globalis_TokeletesKorozes = AGlobalis_TokeletesKorozes
                        End If
                    End If

                    ' Akkor fut le ha l�tezik az adott be�ll�t�s.
                    If InStr(Sor, "Autok_Elso_Nyomvonal") > 0 Then
                        ' Megvizsg�lja hogy "boolean"-e az adat.
                        If IsBoolean(Parse(Sor)) Then
                            ' Be�ll�t�s bet�lt�se.
                            Autok_Elso_Nyomvonal = CBool(Parse(Sor))
                        Else
                            ' Alap�rtelmezett be�ll�t�s bet�lt�se.
                            Autok_Elso_Nyomvonal = AAutok_Elso_Nyomvonal
                        End If
                    End If

                    ' Akkor fut le ha l�tezik az adott be�ll�t�s.
                    If InStr(Sor, "Autok_Elso_TokeletesKorozes") > 0 Then
                        ' Megvizsg�lja hogy "boolean"-e az adat.
                        If IsBoolean(Parse(Sor)) Then
                            ' Be�ll�t�s bet�lt�se.
                            'Autok_Elso_TokeletesKorozes = CBool(Parse(Sor))  ' Kikapcsolva!!!
                        Else
                            ' Alap�rtelmezett be�ll�t�s bet�lt�se.
                            Autok_Elso_TokeletesKorozes = AAutok_Elso_TokeletesKorozes
                        End If
                    End If

                    ' Akkor fut le ha l�tezik az adott be�ll�t�s.
                    If InStr(Sor, "Autok_Masodik_Nyomvonal") > 0 Then
                        ' Megvizsg�lja hogy "boolean"-e az adat.
                        If IsBoolean(Parse(Sor)) Then
                            ' Be�ll�t�s bet�lt�se.
                            Autok_Masodik_Nyomvonal = CBool(Parse(Sor))
                        Else
                            ' Alap�rtelmezett be�ll�t�s bet�lt�se.
                            Autok_Masodik_Nyomvonal = AAutok_Masodik_Nyomvonal
                        End If
                    End If

                    ' Akkor fut le ha l�tezik az adott be�ll�t�s.
                    If InStr(Sor, "Autok_Masodik_TokeletesKorozes") > 0 Then
                        ' Megvizsg�lja hogy "boolean"-e az adat.
                        If IsBoolean(Parse(Sor)) Then
                            ' Be�ll�t�s bet�lt�se.
                            ' Autok_Masodik_TokeletesKorozes = CBool(Parse(Sor)) ' Kikapcsolva!!!
                        Else
                            ' Alap�rtelmezett be�ll�t�s bet�lt�se.
                            Autok_Masodik_TokeletesKorozes = AAutok_Masodik_TokeletesKorozes
                        End If
                    End If

                    ' Akkor fut le ha l�tezik az adott be�ll�t�s.
                    If InStr(Sor, "Autok_Harmadik_Nyomvonal") > 0 Then
                        ' Megvizsg�lja hogy "boolean"-e az adat.
                        If IsBoolean(Parse(Sor)) Then
                            ' Be�ll�t�s bet�lt�se.
                            Autok_Harmadik_Nyomvonal = CBool(Parse(Sor))
                        Else
                            ' Alap�rtelmezett be�ll�t�s bet�lt�se.
                            Autok_Harmadik_Nyomvonal = AAutok_Harmadik_Nyomvonal
                        End If
                    End If

                    ' Akkor fut le ha l�tezik az adott be�ll�t�s.
                    If InStr(Sor, "Autok_Harmadik_TokeletesKorozes") > 0 Then
                        ' Megvizsg�lja hogy "boolean"-e az adat.
                        If IsBoolean(Parse(Sor)) Then
                            ' Be�ll�t�s bet�lt�se.
                            ' Autok_Harmadik_TokeletesKorozes = CBool(Parse(Sor)) ' Kikapcsolva!!!
                        Else
                            ' Alap�rtelmezett be�ll�t�s bet�lt�se.
                            Autok_Harmadik_TokeletesKorozes = AAutok_Harmadik_TokeletesKorozes
                        End If
                    End If

                    ' Akkor fut le ha l�tezik az adott be�ll�t�s.
                    If InStr(Sor, "Autok_Negyedik_Nyomvonal") > 0 Then
                        ' Megvizsg�lja hogy "boolean"-e az adat.
                        If IsBoolean(Parse(Sor)) Then
                            ' Be�ll�t�s bet�lt�se.
                            Autok_Negyedik_Nyomvonal = CBool(Parse(Sor))
                        Else
                            ' Alap�rtelmezett be�ll�t�s bet�lt�se.
                            Autok_Negyedik_Nyomvonal = AAutok_Negyedik_Nyomvonal
                        End If
                    End If

                    ' Akkor fut le ha l�tezik az adott be�ll�t�s.
                    If InStr(Sor, "Autok_Negyedik_TokeletesKorozes") > 0 Then
                        ' Megvizsg�lja hogy "boolean"-e az adat.
                        If IsBoolean(Parse(Sor)) Then
                            ' Be�ll�t�s bet�lt�se.
                            ' Autok_Negyedik_TokeletesKorozes = CBool(Parse(Sor)) ' Kikapcsolva!!!
                        Else
                            ' Alap�rtelmezett be�ll�t�s bet�lt�se.
                            Autok_Negyedik_TokeletesKorozes = AAutok_Negyedik_TokeletesKorozes
                        End If
                    End If
                End If
            End If
        Loop

        ' F�jl lez�s�ra.
        Close #1
    Else
        ' �j konfig f�jl l�trehoz�sa alap�rtelmezett be�ll�t�sokkal.
        CreateConfig True

        ' Konfig be�ll�t�sok bet�lt�se.
        GoTo UjKonfigBetoltese
    End If
End Sub

' Konfig f�jl l�trehoz�sa.
' Az "IsDefault" v�ltoz� t�rolja hogy alap�rtelmezet konfig f�jlt kell-e l�trehozni vagy a konfig f�jlt kell m�dos�tva l�trehozni.
Private Sub CreateConfig(ByVal IsDefault As Boolean)
    Dim TempGlobalis_Nyomvonal As Boolean
    ' Ideiglenes v�ltoz�.
    Dim TempGlobalis_SzektorNevek As Boolean
    ' Ideiglenes v�ltoz�.
    Dim TempGlobalis_StartCelVonalNeve As Boolean
    ' Ideiglenes v�ltoz�.
    Dim TempGlobalis_KorokSzama As Byte
    ' Ideiglenes v�ltoz�.
    Dim TempGlobalis_PalyaNeve As String
    ' Ideiglenes v�ltoz�.
    Dim TempGlobalis_SzektorVonalak As Boolean
    ' Ideiglenes v�ltoz�.
    Dim TempGlobalis_StartCelVonal As Boolean
    ' Ideiglenes v�ltoz�.
    Dim TempGlobalis_TokeletesKorozes As Boolean
    ' Ideiglenes v�ltoz�.
    Dim TempAutok_Elso_Nyomvonal As Boolean
    ' Ideiglenes v�ltoz�.
    Dim TempAutok_Elso_TokeletesKorozes As Boolean
    ' Ideiglenes v�ltoz�.
    Dim TempAutok_Masodik_Nyomvonal As Boolean
    ' Ideiglenes v�ltoz�.
    Dim TempAutok_Masodik_TokeletesKorozes As Boolean
    ' Ideiglenes v�ltoz�.
    Dim TempAutok_Harmadik_Nyomvonal As Boolean
    ' Ideiglenes v�ltoz�.
    Dim TempAutok_Harmadik_TokeletesKorozes As Boolean
    ' Ideiglenes v�ltoz�.
    Dim TempAutok_Negyedik_Nyomvonal As Boolean
    ' Ideiglenes v�ltoz�.
    Dim TempAutok_Negyedik_TokeletesKorozes As Boolean

    ' Akkor fut le ha az alap�rtelmezett be�ll�t�sokat kell be�ll�tani.
    If IsDefault Then
        ' Alap�rtelmezett be�ll�t�s m�sol�sa az ideiglenes v�ltoz�ba.
        TempGlobalis_Nyomvonal = AGlobalis_Nyomvonal
        ' Alap�rtelmezett be�ll�t�s m�sol�sa az ideiglenes v�ltoz�ba.
        TempGlobalis_SzektorNevek = AGlobalis_SzektorNevek
        ' Alap�rtelmezett be�ll�t�s m�sol�sa az ideiglenes v�ltoz�ba.
        TempGlobalis_StartCelVonalNeve = AGlobalis_StartCelVonalNeve
        ' Alap�rtelmezett be�ll�t�s m�sol�sa az ideiglenes v�ltoz�ba.
        TempGlobalis_KorokSzama = AGlobalis_KorokSzama
        ' Alap�rtelmezett be�ll�t�s m�sol�sa az ideiglenes v�ltoz�ba.
        TempGlobalis_PalyaNeve = AGlobalis_PalyaNeve
        ' Alap�rtelmezett be�ll�t�s m�sol�sa az ideiglenes v�ltoz�ba.
        TempGlobalis_SzektorVonalak = AGlobalis_SzektorVonalak
        ' Alap�rtelmezett be�ll�t�s m�sol�sa az ideiglenes v�ltoz�ba.
        TempGlobalis_StartCelVonal = AGlobalis_StartCelVonal
        ' Alap�rtelmezett be�ll�t�s m�sol�sa az ideiglenes v�ltoz�ba.
        TempGlobalis_TokeletesKorozes = AGlobalis_TokeletesKorozes
        ' Alap�rtelmezett be�ll�t�s m�sol�sa az ideiglenes v�ltoz�ba.
        TempAutok_Elso_Nyomvonal = AAutok_Elso_Nyomvonal
        ' Alap�rtelmezett be�ll�t�s m�sol�sa az ideiglenes v�ltoz�ba.
        TempAutok_Elso_TokeletesKorozes = AAutok_Elso_TokeletesKorozes
        ' Alap�rtelmezett be�ll�t�s m�sol�sa az ideiglenes v�ltoz�ba.
        TempAutok_Masodik_Nyomvonal = AAutok_Masodik_Nyomvonal
        ' Alap�rtelmezett be�ll�t�s m�sol�sa az ideiglenes v�ltoz�ba.
        TempAutok_Masodik_TokeletesKorozes = AAutok_Masodik_TokeletesKorozes
        ' Alap�rtelmezett be�ll�t�s m�sol�sa az ideiglenes v�ltoz�ba.
        TempAutok_Harmadik_Nyomvonal = AAutok_Harmadik_Nyomvonal
        ' Alap�rtelmezett be�ll�t�s m�sol�sa az ideiglenes v�ltoz�ba.
        TempAutok_Harmadik_TokeletesKorozes = AAutok_Harmadik_TokeletesKorozes
        ' Alap�rtelmezett be�ll�t�s m�sol�sa az ideiglenes v�ltoz�ba.
        TempAutok_Negyedik_Nyomvonal = AAutok_Negyedik_Nyomvonal
        ' Alap�rtelmezett be�ll�t�s m�sol�sa az ideiglenes v�ltoz�ba.
        TempAutok_Negyedik_TokeletesKorozes = AAutok_Negyedik_TokeletesKorozes
    Else
        ' Be�ll�t�s m�sol�sa az ideiglenes v�ltoz�ba.
        TempGlobalis_Nyomvonal = Globalis_Nyomvonal
        ' Be�ll�t�s m�sol�sa az ideiglenes v�ltoz�ba.
        TempGlobalis_SzektorNevek = Globalis_SzektorNevek
        ' Be�ll�t�s m�sol�sa az ideiglenes v�ltoz�ba.
        TempGlobalis_StartCelVonalNeve = Globalis_StartCelVonalNeve
        ' Be�ll�t�s m�sol�sa az ideiglenes v�ltoz�ba.
        TempGlobalis_KorokSzama = Globalis_KorokSzama
        ' Be�ll�t�s m�sol�sa az ideiglenes v�ltoz�ba.
        TempGlobalis_PalyaNeve = Globalis_PalyaNeve
        ' Be�ll�t�s m�sol�sa az ideiglenes v�ltoz�ba.
        TempGlobalis_SzektorVonalak = Globalis_SzektorVonalak
        ' Be�ll�t�s m�sol�sa az ideiglenes v�ltoz�ba.
        TempGlobalis_StartCelVonal = Globalis_StartCelVonal
        ' Be�ll�t�s m�sol�sa az ideiglenes v�ltoz�ba.
        TempGlobalis_TokeletesKorozes = Globalis_TokeletesKorozes
        ' Be�ll�t�s m�sol�sa az ideiglenes v�ltoz�ba.
        TempAutok_Elso_Nyomvonal = Autok_Elso_Nyomvonal
        ' Be�ll�t�s m�sol�sa az ideiglenes v�ltoz�ba.
        TempAutok_Elso_TokeletesKorozes = Autok_Elso_TokeletesKorozes
        ' Be�ll�t�s m�sol�sa az ideiglenes v�ltoz�ba.
        TempAutok_Masodik_Nyomvonal = Autok_Masodik_Nyomvonal
        ' Be�ll�t�s m�sol�sa az ideiglenes v�ltoz�ba.
        TempAutok_Masodik_TokeletesKorozes = Autok_Masodik_TokeletesKorozes
        ' Be�ll�t�s m�sol�sa az ideiglenes v�ltoz�ba.
        TempAutok_Harmadik_Nyomvonal = Autok_Harmadik_Nyomvonal
        ' Be�ll�t�s m�sol�sa az ideiglenes v�ltoz�ba.
        TempAutok_Harmadik_TokeletesKorozes = Autok_Harmadik_TokeletesKorozes
        ' Be�ll�t�s m�sol�sa az ideiglenes v�ltoz�ba.
        TempAutok_Negyedik_Nyomvonal = Autok_Negyedik_Nyomvonal
        ' Be�ll�t�s m�sol�sa az ideiglenes v�ltoz�ba.
        TempAutok_Negyedik_TokeletesKorozes = Autok_Negyedik_TokeletesKorozes
    End If

    ' F�jl megny�t�sa �r�sra.
    Open ConfigPath For Output As #1

    ' Adatok ki�r�sa a f�jlba.
    Print #1, "# J�t�khoz tartoz� konfig f�jl. Figyelem! Csak hozz��rt�ek piszk�ljanak bele mert hib�t is okozhatnak az �tgondolatlan cselekv�ssel!"
    Print #1, ""
    Print #1, "# Glob�lisan itt kapcsolhat� be vagy ki a nyomvonal."
    Print #1, "Globalis_Nyomvonal = " & CStr(TempGlobalis_Nyomvonal)
    Print #1, "# Glob�lisan itt kapcsolhat� be vagy ki a szektorok neve."
    Print #1, "Globalis_SzektorNevek = " & CStr(TempGlobalis_SzektorNevek)
    Print #1, "# Glob�lisan itt kapcsolhat� be vagy ki a start �s c�lvonal neve."
    Print #1, "Globalis_StartCelVonalNeve = " & CStr(TempGlobalis_StartCelVonalNeve)
    Print #1, "# Itt �ll�that� be h�ny k�r�s legyen az adott verseny. Maximum: 20, Minimum: 2"
    Print #1, "Globalis_KorokSzama = " & TempGlobalis_KorokSzama
    Print #1, "# Itt �ll�that� be a p�lya neve."
    Print #1, "Globalis_PalyaNeve = " & TempGlobalis_PalyaNeve
    Print #1, "# Glob�lisan itt kapcsolhat� be vagy ki a szektorok vonala."
    Print #1, "Globalis_SzektorVonalak = " & CStr(TempGlobalis_SzektorVonalak)
    Print #1, "# Glob�lisan itt kapcsolhat� be vagy ki a start �s c�l vonala."
    Print #1, "Globalis_SCV = " & CStr(TempGlobalis_StartCelVonal)
    Print #1, "# Glob�lisan itt kapcsolhat� be vagy ki a t�k�letes k�r�z�s."
    Print #1, "Globalis_TokeletesKorozes = " & CStr(TempGlobalis_TokeletesKorozes)
    Print #1, ""
    Print #1, "# Els� aut�n�l itt kapcsolhat� be vagy ki a nyomvonal."
    Print #1, "Autok_Elso_Nyomvonal = " & CStr(TempAutok_Elso_Nyomvonal)
    Print #1, "# Els� aut�n�l itt kapcsolhat� be vagy ki a t�k�letes k�r�z�s."
    Print #1, "Autok_Elso_TokeletesKorozes = " & CStr(TempAutok_Elso_TokeletesKorozes)
    Print #1, "# M�sodik aut�n�l itt kapcsolhat� be vagy ki a nyomvonal."
    Print #1, "Autok_Masodik_Nyomvonal = " & CStr(TempAutok_Masodik_Nyomvonal)
    Print #1, "# M�sodik aut�n�l itt kapcsolhat� be vagy ki a t�k�letes k�r�z�s."
    Print #1, "Autok_Masodik_TokeletesKorozes = " & CStr(TempAutok_Masodik_TokeletesKorozes)
    Print #1, "# Harmadik aut�n�l itt kapcsolhat� be vagy ki a nyomvonal."
    Print #1, "Autok_Harmadik_Nyomvonal = " & CStr(TempAutok_Harmadik_Nyomvonal)
    Print #1, "# Harmadik aut�n�l itt kapcsolhat� be vagy ki a t�k�letes k�r�z�s."
    Print #1, "Autok_Harmadik_TokeletesKorozes = " & CStr(TempAutok_Harmadik_TokeletesKorozes)
    Print #1, "# Negyedik aut�n�l itt kapcsolhat� be vagy ki a nyomvonal."
    Print #1, "Autok_Negyedik_Nyomvonal = " & CStr(TempAutok_Negyedik_Nyomvonal)
    Print #1, "# Negyedik aut�n�l itt kapcsolhat� be vagy ki a t�k�letes k�r�z�s."
    Print #1, "Autok_Negyedik_TokeletesKorozes = " & CStr(TempAutok_Negyedik_TokeletesKorozes)

    ' F�jl lez�s�ra.
    Close #1
End Sub

' Be�ll�tja a m�dos�tott adatokat a konfig f�jlban.
Public Sub SetConfig()
    ' Konfig f�jl t�rl�se.
    DeleteConfig
    ' �j konfig f�jl l�trehoz�sa nem alap�rtelmezett be�ll�t�sokkal.
    CreateConfig False
End Sub

' T�rli a konfig f�jlt.
Public Sub DeleteConfig()
    ' Konfig f�jl t�rl�se.
    Kill ConfigPath
End Sub

' Alap�rtelmezett be�ll�t�sok be�ll�t�sa.
Private Sub SetDefault()
    ' Alap�rtelmezett be�ll�t�sa.
    Globalis_Nyomvonal = AGlobalis_Nyomvonal
    ' Alap�rtelmezett be�ll�t�sa.
    Globalis_SzektorNevek = AGlobalis_SzektorNevek
    ' Alap�rtelmezett be�ll�t�sa.
    Globalis_StartCelVonalNeve = AGlobalis_StartCelVonalNeve
    ' Alap�rtelmezett be�ll�t�sa.
    Globalis_KorokSzama = AGlobalis_KorokSzama
    ' Alap�rtelmezett be�ll�t�sa.
    Globalis_PalyaNeve = AGlobalis_PalyaNeve
    ' Alap�rtelmezett be�ll�t�sa.
    Globalis_SzektorVonalak = AGlobalis_SzektorVonalak
    ' Alap�rtelmezett be�ll�t�sa.
    Globalis_StartCelVonal = AGlobalis_StartCelVonal
    ' Alap�rtelmezett be�ll�t�sa.
    Globalis_TokeletesKorozes = AGlobalis_TokeletesKorozes
    ' Alap�rtelmezett be�ll�t�sa.
    Autok_Elso_Nyomvonal = AAutok_Elso_Nyomvonal
    ' Alap�rtelmezett be�ll�t�sa.
    Autok_Elso_TokeletesKorozes = AAutok_Elso_TokeletesKorozes
    ' Alap�rtelmezett be�ll�t�sa.
    Autok_Masodik_Nyomvonal = AAutok_Masodik_Nyomvonal
    ' Alap�rtelmezett be�ll�t�sa.
    Autok_Masodik_TokeletesKorozes = AAutok_Masodik_TokeletesKorozes
    ' Alap�rtelmezett be�ll�t�sa.
    Autok_Harmadik_Nyomvonal = AAutok_Harmadik_Nyomvonal
    ' Alap�rtelmezett be�ll�t�sa.
    Autok_Harmadik_TokeletesKorozes = AAutok_Harmadik_TokeletesKorozes
    ' Alap�rtelmezett be�ll�t�sa.
    Autok_Negyedik_Nyomvonal = AAutok_Negyedik_Nyomvonal
    ' Alap�rtelmezett be�ll�t�sa.
    Autok_Negyedik_TokeletesKorozes = AAutok_Negyedik_TokeletesKorozes
End Sub

' Sz�tv�gja a bet�lt�tt sorokat. Majd visszadja az �rt�kes adatokat.
' A "Sor" v�ltoz� a konfig f�jl egy sor�t tartalmazza ami �ppen kiolvas�sra ker�lt.
Private Function Parse(ByVal Sor As String) As String
    ' Egyenl�s�g jel ut�ni r�szt adja vissza. A felesleges adatokat elt�vol�tja (pl: sz�k�z).
    Parse = LTrim(Mid$(Sor, InStr(1, Sor, "=") + 1))
End Function
