---
title: Sort Algorithms
author: Louis Nguyen
date: 2021-05-17 20:55:00 +0700
categories: [Algorithm, Sort]
tags: [algorithm, sort]
pin: true
comments: true
---

## Util functions
```cpp
// Swap values
void Swap(int &a, int &b)
{
	int t;
	t = a;
	a = b;
	b = t;
}
```

### Interchange sort
```cpp
void InterchangeSort(int a[], int N)
{
	int i, j;
	for (i = 0; i < N - 1; i++)
		for (j = i + 1; j < N; j++)
			if (a[j] < a[i])
				Swap(a[i], a[j]);
}
```

### Selection Sort
```cpp
void SelectionSort(int a[], int n)
{
	int min, i, j, t;
	for (i = 0; i < n - 1; i++)
	{
		min = i;
		for (j = i + 1; j < n; j++)
			if (a[j] < a[min])
				min = j;
		Swap(a[i], a[min]);
	}
}
```

### Bubble Sort
```cpp
void BubbleSort(int a[], int n)
{
	int i, j;
	for (i = 0; i<n - 1; i++)
		for (j = n - 1; j >i; j--)
			if (a[j]< a[j - 1])
				Swap(a[j], a[j - 1]);
}
```

### Shake Sort
```cpp
void ShakeSort(int a[], int n)
{
	int i, j;
	int left, right, k;
	left = 0; right = n - 1; k = n - 1;
	while (left < right)
	{
		for (j = right; j > left; j--)
			if (a[j] < a[j - 1])
			{
				Swap(a[j], a[j - 1]);
				k = j;
			}
		left = k;

		for (i = left; i < right; i++)
			if (a[i] > a[i + 1])
			{
				Swap(a[i], a[i + 1]);
				k = i;
			}
		right = k;
	}
}
```

### Insertion Sort
```cpp
void InsertionSort(int a[], int n)
{
	int pos, i;
	int x;
	for (i = 1; i<n; i++)
	{
		x = a[i];
		pos = i - 1;
		while ((pos >= 0) && (a[pos] > x))
		{
			a[pos + 1] = a[pos];
			pos--;
		}
		a[pos + 1] = x;
	}
}
```

### Binary Insertion Sort
```cpp
void BInsertionSort(int a[], int n)
{
	int l, r, m, i;
	int x;
	for (int i = 1; i<n; i++)
	{
		x = a[i]; l = 0; r = i - 1;
		while (l <= r)
		{
			m = (l + r) / 2;
			if (x < a[m]) r = m - 1;
			else l = m + 1;
		}
		for (int j = i - 1; j >= l; j--)
			a[j + 1] = a[j];
		a[l] = x;
	}
}
```

### Shell Sort
```cpp
void ShellSort(int a[], int n, int h[], int k)
{
	int step, i, j, x, len;
	for (step = 0; step <k; step++)
	{
		len = h[step];
		for (i = len; i < n; i++)
		{
			x = a[i];
			j = i - len;
			while ((x < a[j]) && (j >= 0))
			{
				a[j + len] = a[j];
				j = j - len;
			}
			a[j + len] = x;
		}
	}
}
```

### Heap Sort
```cpp
void shift(int a[], int l, int r)
{
	int x, i, j;
	i = l;
	j = 2 * i + 1;
	x = a[i];
	while (j <= r)
	{
		if (j < r)
			if (a[j] < a[j + 1])
				j++;
		if (a[j] <= x) return;
		else
		{
			a[i] = a[j];
			a[j] = x;
			i = j;
			j = 2 * i + 1;
			x = a[i];
		}
	}
}
void CreateHeap(int a[], int n) {
	int l;
	l = n / 2 - 1;
	while (l >= 0) {
		shift(a, l, n - 1);
		l = l - 1;
	}
}
void HeapSort(int a[], int n)
{
	int r;
	CreateHeap(a, n);
	r = n - 1;
	while (r > 0)
	{
		Swap(a[0], a[r]);
		r--;
		if (r > 0)
			shift(a, 0, r);
	}
}
```

### Quick Sort
```cpp
void QuickSort(int a[], int left, int right) {
	int i, j, x;
	x = a[(left + right) / 2];
	i = left; j = right;
	do{
		while (a[i] < x) i++;
		while (a[j] > x) j--;
		if (i <= j)
		{
			Swap(a[i], a[j]);
			i++;
			j--;
		}
	} while (i <= j);
	if (left<j)
		QuickSort(a, left, j);
	if (i<right)
		QuickSort(a, i, right);
}
```


### Merge Sort
```cpp
#define MAX 1024
int b[MAX], c[MAX], nb, nc;
void Distribute(int a[], int N, int &nb, int &nc, int k)
{
	int i, pa, pb, pc;
	pa = pb = pc = 0;
	while (pa < N)
	{
		for (i = 0; (pa < N) && (i < k); i++, pa++, pb++)
			b[pb] = a[pa];
		for (i = 0; (pa < N) && (i < k); i++, pa++, pc++)
			c[pc] = a[pa];
	}
	nb = pb;
	nc = pc;
}
int timmin(int a, int b)
{
	if (a > b) return b;
	else a;
}
void Merge(int a[], int nb, int nc, int k)
{
	int p, pb, pc, ib, ic, kb, kc;
	p = pb = pc = 0;
	ib = ic = 0;
	while ((nb > 0) && (nc > 0))
	{
		kb = timmin(k, nb);
		kc = timmin(k, nc);
		if (b[pb + ib] <= c[pc + ic])
		{
			a[p++] = b[pb + ib]; ib++;
			if (ib == kb)
			{
				for (; ic < kc; ic++)
					a[p++] = c[pc + ic];
				pb += kb;
				pc += kc;
				ib = ic = 0;
				nb -= kb;
				nc -= kc;
			}
		}
		else
		{
			a[p++] = c[pc + ic]; ic++;
			if (ic == kc)
			{
				for (; ib<kb; ib++) a[p++] = b[pb + ib];
				pb += kb; pc += kc; ib = ic = 0;
				nb -= kb; nc -= kc;
			}
		}
	}
}

void MergeSort(int a[], int n)
{
	int k;
	for (k = 1; k < n; k *= 2) {
		Distribute(a, n, nb, nc, k);
		Merge(a, nb, nc, k);
	}
}
```
