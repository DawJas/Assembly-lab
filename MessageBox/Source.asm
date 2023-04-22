.686
.model flat
extern _ExitProcess@4 : PROC
extern __write : PROC ; (dwa znaki podkreœlenia)
extern __read : PROC ; (dwa znaki podkreœlenia)
extern _MessageBoxW@16 : PROC
public _main
.data
tekst_pocz db 10, 'Proszê napisaæ jakiœ tekst '
db 'i nacisnac Enter', 10
koniec_t db ?
magazyn db 80 dup (?)
nowa_linia db 10
liczba_znakow dd ?
tytul dw 't','y','t','u','l', 0
tekst dw 3 dup (?) ,0

.code
_main PROC

 mov ecx,(OFFSET koniec_t) - (OFFSET tekst_pocz)
 push ecx
 push OFFSET tekst_pocz ; adres tekstu
 push 1 ; nr urz¹dzenia (tu: ekran - nr 1)
 call __write ; wyœwietlenie tekstu pocz¹tkowego
 add esp, 12 ; usuniecie parametrów ze stosu
; czytanie wiersza z klawiatury

 push 80 ; maksymalna liczba znaków
 push OFFSET magazyn
 push 0 ; nr urz¹dzenia (tu: klawiatura - nr 0)
 call __read ; czytanie znaków z klawiatury
 add esp, 12 ; usuniecie parametrów ze stosu

; kody ASCII napisanego tekstu zosta³y wprowadzone
; do obszaru 'magazyn'
; funkcja read wpisuje do rejestru EAX liczbê
; wprowadzonych znaków
 mov liczba_znakow, eax
; rejestr ECX pe³ni rolê licznika obiegów pêtli

 mov ecx, eax
 mov ebx, 0 ; indeks pocz¹tkowy
 mov al, byte PTR 0

ptl: mov dl, magazyn[ebx] ; pobranie kolejnego znaku
cmp dl, 57
jbe cyfra
cmp dl, 141
jae polska

polska:
cmp dl,164
je dodaj
cmp dl,143
je dodaj
cmp dl,168
je dodaj
cmp dl,157
je dodaj
cmp dl,227
je dodaj
cmp dl,224
je dodaj
cmp dl,151
je dodaj
cmp dl,141
je dodaj
cmp dl,189
je dodaj

jmp dalej

dodaj:
add al, byte PTR 1
jmp dalej

cyfra: 
cmp dl, 48
jbe dalej
sub dl, 48
mov dh, dl
jmp dalej

 dalej: inc ebx ; inkrementacja indeksu
 loop ptl ; sterowanie pêtl¹

 cmp dh, al
 jbe kura
 jmp zaba

 
 kura:
 add al, 48
 mov ecx, offset tekst  
 mov [ecx], ax 
 mov [ecx+2], word PTR 0D83DH  
 mov [ecx+4], word PTR  0DC14H
 jmp wypisz

 zaba:
 add al,48
  mov ecx, offset tekst
  mov [ecx], ax
 mov [ecx+2], word PTR 0D83DH
 mov [ecx+4], word PTR 0DC38H
 wypisz:
 push 0

push OFFSET tytul
 push OFFSET tekst

 push 0 ; NULL
 call _MessageBoxW@16
 push 0 ; kod powrotu programu
 call _ExitProcess@4 ; zakoñczenie programu
_main ENDP
END
