#define _CRT_SECURE_NO_WARNINGS
#include <stdio.h>


int mse_loss(int tab1[], int tab2[], int n);
int* merge_reversed(int tab1[], int tab2[], int n);

int main()
{
	int n;
	scanf("%d", &n);
	int* tab1 = malloc(sizeof(int) * n);
	int* tab2 = malloc(sizeof(int) * n);
	printf("Podaj zawartosc pierwszego wektora:\n");
	for (int i = 0; i < n; i++) scanf("%d", &tab1[i]);
	printf("Podaj zawartosc drugiego wektora:\n");
	for (int i = 0; i < n; i++) scanf("%d", &tab2[i]);
/*	 int c = mse_loss(tab1, tab2, n);
	printf("\n%d", c);*/
	int* nowa = merge_reversed(tab1, tab2, n);
	if (nowa != 0) {
		for (int i = 0; i < 2 * n; i++) {
			printf("%d ", nowa[i]);
		}
	}
	else printf("B£¥D!");
	
	return 0;
}