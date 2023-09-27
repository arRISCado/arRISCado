/* Example: function of Insert Short */

void troca(int *a, int *b) {
    int aux;
    aux = *a;
    *a = *b;
    *b = aux;
}

void selectionsort(int *v, int n) {
    int i, j, min;
    for (i = 0; i < n - 1; i++) {
        min = i;
        for (j = i+1; j < n; j++)
            if (v[j] < v[min])
                min = j;
        troca(&v[i], &v[min]);
    }
}

int main() {
    int n=5, list [5] = {4, 2, 1, 3, 0};
    selectionsort(list, n);

    return 0;
}
