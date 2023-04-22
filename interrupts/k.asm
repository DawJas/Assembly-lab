
; Program linie.asm
; Wyswietlanie znakow * w takt przerwan zegarowych
; Uruchomienie w trybie rzeczywistym procesora x86
; lub na maszynie wirtualnej
; zakonczenie programu po nacisnieciu dowolnego klawisza
; asemblacja (MASM 4.0): masm gwiazdki.asm,,,;
; konsolidacja (LINK 3.60): link gwiazdki.obj;
.386
rozkazy SEGMENT use16
ASSUME cs:rozkazy

klawa PROC

push ax

in al, 60h
cmp al, 19
jne dalej6
mov cs:kolor_alternatywny, 40
jmp dalej6

dalej6:

pop ax
jmp dword ptr cs:wektor9
klawa ENDP

linia PROC
; przechowanie rejestrow
push ax
push bx
push cx
push dx
push es
mov ax, 0A000H ; adres pamieci ekranu dla trybu 13H
mov es, ax

add cs:licznik,1
cmp cs:licznik,4
jne dalej2
mov dl, cs:kolor_alternatywny
cmp cs:kolor, 0
jne ustawCzarny
mov cs:kolor, dl

jmp dalej3
ustawCzarny:
mov cs:kolor, 0
dalej3:
mov cs:licznik,0
dalej2:

mov al, cs:kolor

mov dx, 40
mov bx, 320*100+140

petla:
mov cx, 40
gora:
mov es:[bx], al
add bx, 1
loop gora
add bx, 280
dec dx
jnz petla



; sprawdzenie czy cala linia wykreslona
cmp bx, 320*200
jb dalej ; skok, gdy linia jeszcze nie wykreslona
; kreslenie linii zostalo zakonczone - nastepna linia bedzie
; kreslona w innym kolorze o 10 pikseli dalej
add word PTR cs:przyrost, 10
mov bx, 10
add bx, cs:przyrost
inc cs:kolor ; kolejny kod koloru
; zapisanie adresu biezacego piksela
dalej:
mov cs:adres_piksela, bx
; odtworzenie rejestrow
pop es
pop dx
pop cx
pop bx
pop ax
; skok do oryginalnego podprogramu obslugi przerwania
; zegarowego
jmp dword PTR cs:wektor8
; zmienne procedury
kolor db 0EH ; biezacy numer koloru
kolor_alternatywny db 0EH ; biezacy numer koloru
licznik db 0 ; biezacy numer koloru
adres_piksela dw 10 ; biezacy adres piksela
przyrost dw 0
wektor8 dd ?
wektor9 dd ?
wyjdz db 0
linia ENDP
; INT 10H, funkcja nr 0 ustawia tryb sterownika graficznego
zacznij:
mov ah, 0
mov al, 13H ; nr trybu
int 10H
mov bx, 0
mov es, bx ; zerowanie rejestru ES
mov eax, es:[32] ; odczytanie wektora nr 8
mov cs:wektor8, eax; zapamietanie wektora nr 8
; adres procedury 'linia' w postaci segment:offset
mov ax, SEG linia
mov bx, OFFSET linia
cli ; zablokowanie przerwan
; zapisanie adresu procedury 'linia' do wektora nr 8
mov es:[32], bx
mov es:[32+2], ax


mov eax, es:[36] ; odczytanie wektora nr 8
mov cs:wektor9, eax; zapamietanie wektora nr 8
; adres procedury 'linia' w postaci segment:offset
mov ax, SEG klawa
mov bx, OFFSET klawa

mov es:[36], bx
mov es:[36+2], ax

sti ; odblokowanie przerwan
aktywne_oczekiwanie:
mov ah,1
int 16H 
jz aktywne_oczekiwanie
mov ah, 0
int 16H
cmp al, 'x'
jne aktywne_oczekiwanie


mov ah, 0 ; funkcja nr 0 ustawia tryb sterownika
mov al, 3H ; nr trybu
int 10H
; odtworzenie oryginalnej zawartosci wektora nr 8
mov eax, cs:wektor8
mov es:[32], eax

mov eax, cs:wektor9
mov es:[36], eax
; zakonczenie wykonywania programu
mov ax, 4C00H
int 21H
rozkazy ENDS
stosik SEGMENT stack
db 256 dup (?)
stosik ENDS
END zacznij