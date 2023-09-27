/* Example: function of fibonacci */

int fibonacci(int n) {
    if (n <= 1) {
        return n;
    } else {
        return fibonacci(n - 1) + fibonacci(n - 2);
    }
}

int main() {
    int n=5, result;
    result = fibonacci(n);

    return 0;
}
