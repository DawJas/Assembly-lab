.686
.model flat
public _mse_loss
public _merge_reversed
extern _malloc : PROC
.code
_mse_loss PROC

push ebp
mov ebp, esp

sub esp, 24

push ebx
push ecx
push esi
push edi

mov ebx, [ebp+8]; EBP +4 => ADRES TAB2
mov edx, [ebp+12]; EBP +8 => ADRES TAB1
mov ecx, [ebp+16]; EBP +12 => liczba liczb
mov [ebp-4], dword PTR 0 ;EBP => -4 - SUMA CALKOWIA
mov [ebp-8], dword PTR 0 ;EBP => -8 - SUMA CZESCOIWA
mov [ebp-12], dword PTR 0 ;EBP => -12 - ADRES TAB1
mov edx, [edx]
mov [ebp-12], edx


mov edi, 0
petla:
mov [ebp-8], dword PTR 0 ;EBP => -8 - SUMA CZESCOIWA
mov ebx, [ebp+8]; EBP +4 => ADRES TAB2
add ebx, edi
mov esi, [ebx];
add [ebp-8], esi
mov ebx, [ebp+12]; EBP +4 => ADRES TAB2
add ebx, edi
mov esi,[ebx]
sub [ebp-8], esi
mov eax, [ebp-8]
mov edx, 0
imul eax
add [ebp-4], eax
add edi, 4
loop petla

mov edx, 0
mov eax, [ebp-4]
mov esi, [ebp+16]
div esi

mov [ebp-20], edx ;=>reszta

mov eax, esi
mov ecx, 2
div ecx

cmp eax, [ebp-20]
je skok

mov edx, 0
mov eax, [ebp-4]
mov esi, [ebp+16]
div esi

inc eax
jmp end2
skok:
mov edx, 0
mov eax, [ebp-4]
mov esi, [ebp+16]
div esi
end2:
pop edi
pop esi
pop ecx
pop ebx
add esp, 24
pop ebp
ret

_mse_loss ENDP

_merge_reversed PROC
push ebp
mov ebp, esp
;[EBP+8] => ADRES TABLICA 1
;[EBP+12] => ADRES TABLICA 2
;[EBP+16] => ROZMIAR
sub esp, 20
push ebx
push ecx
push esi
push edi
;
mov ecx, [ebp+16]
cmp ecx, 32
jge zlyKoniec
add ecx, ecx
add ecx, ecx
add ecx, ecx
push ecx
call _malloc
pop ecx
cmp eax, 0
je koniec
mov [ebp-4], eax ;EBP -4 => ADRES NOWEJ TABLICY

mov ecx, [ebp+16]
mov ebx, 0
petla:
mov edx, [ebp+8]
mov esi, [edx+ebx]
mov [eax+ebx], esi
add ebx, 4
loop petla

mov edi, 0
mov ecx, [ebp+16]

petla2:
mov edx, [ebp+12]
mov esi, [edx+4*ecx-4]
mov [eax+ebx], esi
add ebx,4
add edi, 4
loop petla2
;
mov eax, [ebp-4]
jmp koniec

zlyKoniec:
mov eax, 0
koniec:
pop edi
pop esi
pop ecx
pop ebx
add esp,20
pop ebp
ret
_merge_reversed ENDP
END



 END

