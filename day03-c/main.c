#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdbool.h>
#include <ctype.h>

typedef struct {
    int value;
    bool adjacent;
} Cell;

#define N 140
/* #define N 10 */

int sol1(FILE* file) {
    char contents[200];
    Cell cells[N][N];
    memset(cells, 0, sizeof cells);
    for (int row=0; row < N; row++) {
        fgets(contents, 200, file);
        for (int col = 0; col < strlen(contents); col++) {
            char c = contents[col];
            int num = c - '0';
            if (c == '.') {
                // Do nothing
            } else if (num >= 0 && num < 10) {
                // A number
                cells[row][col].value = num;
                if (col != 0) {
                    cells[row][col].value += 10 * cells[row][col-1].value;
                }
            } else {
                // a symbol, look at surrounding places
                if (!isspace(c)) {
                    for (int i=row-1; i<=row+1; i++) {
                        for (int j=col-1; j<=col+1; j++) {
                            cells[i][j].adjacent = true;
                        }
                    }
                }
            }
        }
    }
    int total = 0;
    for (int i=0; i<N; i++) {
        int current = 0;
        for (int j=0; j<N; j++) {
            if (cells[i][j].adjacent) {
                int value = cells[i][j].value;
                if (value == 0) {
                    total += current;
                    current = 0;
                } else {
                    current = value;
                    if (j != N-1) {
                        cells[i][j+1].adjacent = true;
                    } else {
                        total += current;
                    }
                }
            }
        }
    }
    return total;
}

typedef struct {
    int id;
    int value;
} Cell2;

int sol2(FILE* file) {
    char contents[200];
    Cell2 cells[N][N];
    memset(cells, 0, sizeof cells);
    int id = 1;
    for (int row=0; row < N; row++) {
        fgets(contents, 200, file);
        for (int col=0; col<strlen(contents); col++) {
            char c = contents[col];
            int num = c - '0';
            if (num >= 0 && num < 10) {
                // A number
                cells[row][col].value = num;
                cells[row][col].id = id;
                id++;
                if (col != 0) {
                    Cell2* prev = &cells[row][col-1];
                    if (prev->value > 0) {
                        // Assign same value to the same ids
                        cells[row][col].value += 10 * prev->value;
                        cells[row][col].id = prev->id;
                        int rollback = 2;
                        while (prev->id  == cells[row][col].id) {
                            prev->value = cells[row][col].value;
                            prev = &cells[row][col-rollback];
                            rollback++;
                        }
                    }
                }
            } else if (c == *"*") {
                // Mark gear
                cells[row][col].value = -1;
            }
        }
    }
    int total = 0;
    for (int i=0; i<N; i++) {
        for (int j=0; j<N; j++) {
            int val = cells[i][j].value;
            // if Gear
            if (val == -1) {
                int max_id = 0;
                int gear = 1;
                int count = 0;
                for (int a=i-1; a<=i+1; a++) {
                    for (int b=j-1; b<=j+1; b++) {
                        Cell2 this = cells[a][b];
                        // count unique ids
                        if (this.id > max_id) {
                            max_id = this.id;
                            if (this.value > 0 && count <= 2) {
                                gear *= this.value;
                            }
                            count++;
                        }
                    }
                }
                if (count == 2) {
                    total += gear;
                }
            }
        } 
    }
    return total;
} 

int main() {
    FILE *file;

    file = fopen("input.txt", "r");
    int answer1 = sol1(file);
    printf("Solution 1: %d\n", answer1);
    fclose(file);

    file = fopen("input.txt", "r");
    int answer2 = sol2(file);
    printf("Solution 2: %d\n", answer2);
    fclose(file);

    return 0;
}


