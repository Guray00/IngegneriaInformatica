#include <iostream>
#include <fstream>
#include <math.h>
using namespace std;

extern const int PASSO_MAX;
extern const double ERR_MAX;

unsigned long long mcd(unsigned long long m, unsigned long long n);
unsigned long long mcm(unsigned long long m, unsigned long long n);

void Quicksort(unsigned int* arr, int n)
{
	if (n <= 1)
		return;
	int i = 0, j = n - 1;
	unsigned int pivot = arr[n / 2];
	while (i <= j)
	{
		while (arr[i] < pivot)
			i++;
		while (arr[j] > pivot)
			j--;
		if (i >= j)
			break;
		unsigned int t = arr[j];
		arr[j] = arr[i];
		arr[i] = t;
		i++;
		j--;
	}
	Quicksort(arr, i);
	if (i == j)
		i++;
	Quicksort(arr + i, n - i);
}

class frac
{
	int num;
	unsigned int den;
	frac(long double val, int passo_n);
public:
	frac()
	{
		num = 0;
		den = 0;
	}
	frac(bool val)
	{
		if (val)
			num = 1;
		else
			num = 0;
		den = 1;
	}
	frac(unsigned char val)
	{
		num = (int)val;
		den = 1;
	}

	frac(short val)
	{
		num = (int)val;
		den = 1;
	}
	frac(unsigned short val)
	{
		num = (int)val;
		den = 1;
	}
	frac(int val)
	{
		num = (int)val;
		den = 1;
	}
	frac(unsigned int val)
	{
		if (val > INT_MAX)
		{
			num = 1;
			den = 0;
			return;
		}
		num = (int)val;
		den = 1;
	}
	frac(long val)
	{
		if (val > (long)INT_MAX)
		{
			num = 1;
			den = 0;
			return;
		}
		if (val < (long)INT_MIN)
		{
			num = -1;
			den = 0;
			return;
		}
		num = (int)val;
		den = 1;
	}
	frac(unsigned long val)
	{
		if (val > (unsigned long)INT_MAX)
		{
			num = 1;
			den = 0;
			return;
		}
		num = (int)val;
		den = 1;
	}
	frac(long long val)
	{
		if (val > (long long)INT_MAX)
		{
			num = 1;
			den = 0;
			return;
		}
		if (val < (long long)INT_MIN)
		{
			num = -1;
			den = 0;
			return;
		}
		num = (int)val;
		den = 1;
	}
	frac(unsigned long long val)
	{
		if (val > (unsigned long long)INT_MAX)
		{
			num = 1;
			den = 0;
			return;
		}
		num = (int)val;
		den = 1;
	}
	frac(float val)
	{
		*this = frac((long double)val);
	}
	frac(double val)
	{
		*this = frac((long double)val);
	}
	frac(long double val);
	frac(long long new_num, unsigned long long new_den);

	int get_numerator()
	{
		return num;
	}

	unsigned int get_denominator()
	{
		return den;
	}

	template <typename N, typename D>frac(N Num, D Den)
	{
		if (Den < 0)
		{
			Den *= -1;
			Num *= -1;
		}
		*this = frac((long long)Num, (unsigned long long) Den);
	}
	operator bool()
	{
		if (num == 0 && den != 0)
			return false;
		else
			return true;
	}
	operator unsigned char()
	{
		return (unsigned char)(num / den);
	}
	operator short()
	{
		return short(num / den);
	}
	operator unsigned short()
	{
		return (unsigned short)(num / den);
	}
	operator int()
	{
		return int(num / den);
	}
	operator unsigned int()
	{
		return (unsigned int)(num / den);
	}
	operator long()
	{
		return long(num / den);
	}
	operator unsigned long()
	{
		return (unsigned long)(num / den);
	}
	operator long long()
	{
		return (long long)(num / den);
	}
	operator unsigned long long()
	{
		return (unsigned long long)(num / den);
	}
	operator float()
	{
		return float((long double)num / (long double)den);
	}
	operator double()
	{
		return double((long double)num / (long double)den);
	}
	operator long double()
	{
		return (long double)((long double)num / (long double)den);
	}

	frac& operator+=(frac f2)
	{
		*this = *this + f2;
		return *this;
	}
	frac& operator-=(frac f2)
	{
		*this = *this - f2;
		return *this;
	}
	frac& operator*=(frac f2)
	{
		*this = *this * f2;
		return *this;
	}
	frac& operator/=(frac f2)
	{
		*this = *this / f2;
		return *this;
	}

	frac& operator++()
	{
		*this = *this + frac(1);
		return *this;
	}
	const frac operator++(int a)
	{
		frac ret = *this;
		*this = *this + frac(1);
		return ret;
	}

	frac& operator--()
	{
		*this = *this - frac(1);
		return *this;
	}
	const frac operator--(int a)
	{
		frac ret = *this;
		*this = *this - frac(1);
		return ret;
	}

	frac operator-()
	{
		frac res;
		res.num = num;
		res.den = den;
		if (num == INT_MIN)
		{
			res.num = 1;
			res.den = 0;
			return res;
		}
		res.num *= -1;
		return res;
	}

	frac operator+()
	{
		return *this;
	}

	friend frac operator+(frac f1, frac f2);
	friend frac operator-(frac f1, frac f2);
	friend frac operator*(frac f1, frac f2);
	friend frac operator/(frac f1, frac f2);

	friend bool operator ==(frac f1, frac f2);
	friend bool operator >(frac f1, frac f2);
	friend bool operator <(frac f1, frac f2);
	friend bool operator >=(frac f1, frac f2);
	friend bool operator <=(frac f1, frac f2);
	friend bool operator !=(frac f1, frac f2);
	friend std::ostream& operator<<(std::ostream& out, frac f);
	friend std::istream& operator>>(std::istream& in, frac& f);
	friend std::wostream& operator<<(std::wostream& out, frac f);
	friend std::wistream& operator>>(std::wistream& in, frac& f);
	friend frac abs(frac f);
	friend int floor(frac f);
};

frac operator+(double f1, frac f2)
{
	return frac(f1) + f2;
}
frac operator-(double f1, frac f2)
{
	return frac(f1) - f2;
}
frac operator*(double f1, frac f2)
{
	return frac(f1) * f2;
}
frac operator/(double f1, frac f2)
{
	return frac(f1) / f2;
}

frac operator+(frac f1, double f2)
{
	return f1 + frac(f2);
}
frac operator-(frac f1, double f2)
{
	return f1 - frac(f2);
}
frac operator*(frac f1, double f2)
{
	return f1 * frac(f2);
}
frac operator/(frac f1, double f2)
{
	return f1 / frac(f2);
}

bool operator==(double f1, frac f2)
{
	return frac(f1) == f2;
}
bool operator>(double f1, frac f2)
{
	return frac(f1) > f2;
}
bool operator<(double f1, frac f2)
{
	return frac(f1) < f2;
}
bool operator>=(double f1, frac f2)
{
	return frac(f1) >= f2;
}
bool operator<=(double f1, frac f2)
{
	return frac(f1) <= f2;
}
bool operator!=(double f1, frac f2)
{
	return frac(f1) != f2;
}

bool operator==(frac f1, double f2)
{
	return f1 == frac(f2);
}
bool operator>(frac f1, double f2)
{
	return f1 > frac(f2);
}
bool operator<(frac f1, double f2)
{
	return f1 < frac(f2);
}
bool operator>=(frac f1, double f2)
{
	return f1 >= frac(f2);
}
bool operator<=(frac f1, double f2)
{
	return f1 <= frac(f2);
}
bool operator!=(frac f1, double f2)
{
	return f1 != frac(f2);
}


frac operator+(float f1, frac f2)
{
	return frac(f1) + f2;
}
frac operator-(float f1, frac f2)
{
	return frac(f1) - f2;
}
frac operator*(float f1, frac f2)
{
	return frac(f1) * f2;
}
frac operator/(float f1, frac f2)
{
	return frac(f1) / f2;
}

frac operator+(frac f1, float f2)
{
	return f1 + frac(f2);
}
frac operator-(frac f1, float f2)
{
	return f1 - frac(f2);
}
frac operator*(frac f1, float f2)
{
	return f1 * frac(f2);
}
frac operator/(frac f1, float f2)
{
	return f1 / frac(f2);
}

bool operator==(float f1, frac f2)
{
	return frac(f1) == f2;
}
bool operator>(float f1, frac f2)
{
	return frac(f1) > f2;
}
bool operator<(float f1, frac f2)
{
	return frac(f1) < f2;
}
bool operator>=(float f1, frac f2)
{
	return frac(f1) >= f2;
}
bool operator<=(float f1, frac f2)
{
	return frac(f1) <= f2;
}
bool operator!=(float f1, frac f2)
{
	return frac(f1) != f2;
}

bool operator==(frac f1, float f2)
{
	return f1 == frac(f2);
}
bool operator>(frac f1, float f2)
{
	return f1 > frac(f2);
}
bool operator<(frac f1, float f2)
{
	return f1 < frac(f2);
}
bool operator>=(frac f1, float f2)
{
	return f1 >= frac(f2);
}
bool operator<=(frac f1, float f2)
{
	return f1 <= frac(f2);
}
bool operator!=(frac f1, float f2)
{
	return f1 != frac(f2);
}


frac operator+(short f1, frac f2)
{
	return frac(f1) + f2;
}
frac operator-(short f1, frac f2)
{
	return frac(f1) - f2;
}
frac operator*(short f1, frac f2)
{
	return frac(f1) * f2;
}
frac operator/(short f1, frac f2)
{
	return frac(f1) / f2;
}

frac operator+(frac f1, short f2)
{
	return f1 + frac(f2);
}
frac operator-(frac f1, short f2)
{
	return f1 - frac(f2);
}
frac operator*(frac f1, short f2)
{
	return f1 * frac(f2);
}
frac operator/(frac f1, short f2)
{
	return f1 / frac(f2);
}

bool operator==(short f1, frac f2)
{
	return frac(f1) == f2;
}
bool operator>(short f1, frac f2)
{
	return frac(f1) > f2;
}
bool operator<(short f1, frac f2)
{
	return frac(f1) < f2;
}
bool operator>=(short f1, frac f2)
{
	return frac(f1) >= f2;
}
bool operator<=(short f1, frac f2)
{
	return frac(f1) <= f2;
}
bool operator!=(short f1, frac f2)
{
	return frac(f1) != f2;
}

bool operator==(frac f1, short f2)
{
	return f1 == frac(f2);
}
bool operator>(frac f1, short f2)
{
	return f1 > frac(f2);
}
bool operator<(frac f1, short f2)
{
	return f1 < frac(f2);
}
bool operator>=(frac f1, short f2)
{
	return f1 >= frac(f2);
}
bool operator<=(frac f1, short f2)
{
	return f1 <= frac(f2);
}
bool operator!=(frac f1, short f2)
{
	return f1 != frac(f2);
}


frac operator+(int f1, frac f2)
{
	return frac(f1) + f2;
}
frac operator-(int f1, frac f2)
{
	return frac(f1) - f2;
}
frac operator*(int f1, frac f2)
{
	return frac(f1) * f2;
}
frac operator/(int f1, frac f2)
{
	return frac(f1) / f2;
}

frac operator+(frac f1, int f2)
{
	return f1 + frac(f2);
}
frac operator-(frac f1, int f2)
{
	return f1 - frac(f2);
}
frac operator*(frac f1, int f2)
{
	return f1 * frac(f2);
}
frac operator/(frac f1, int f2)
{
	return f1 / frac(f2);
}

bool operator==(int f1, frac f2)
{
	return frac(f1) == f2;
}
bool operator>(int f1, frac f2)
{
	return frac(f1) > f2;
}
bool operator<(int f1, frac f2)
{
	return frac(f1) < f2;
}
bool operator>=(int f1, frac f2)
{
	return frac(f1) >= f2;
}
bool operator<=(int f1, frac f2)
{
	return frac(f1) <= f2;
}
bool operator!=(int f1, frac f2)
{
	return frac(f1) != f2;
}

bool operator==(frac f1, int f2)
{
	return f1 == frac(f2);
}
bool operator>(frac f1, int f2)
{
	return f1 > frac(f2);
}
bool operator<(frac f1, int f2)
{
	return f1 < frac(f2);
}
bool operator>=(frac f1, int f2)
{
	return f1 >= frac(f2);
}
bool operator<=(frac f1, int f2)
{
	return f1 <= frac(f2);
}
bool operator!=(frac f1, int f2)
{
	return f1 != frac(f2);
}


frac operator+(long long f1, frac f2)
{
	return frac(f1) + f2;
}
frac operator-(long long f1, frac f2)
{
	return frac(f1) - f2;
}
frac operator*(long long f1, frac f2)
{
	return frac(f1) * f2;
}
frac operator/(long long f1, frac f2)
{
	return frac(f1) / f2;
}

frac operator+(frac f1, long long f2)
{
	return f1 + frac(f2);
}
frac operator-(frac f1, long long f2)
{
	return f1 - frac(f2);
}
frac operator*(frac f1, long long f2)
{
	return f1 * frac(f2);
}
frac operator/(frac f1, long long f2)
{
	return f1 / frac(f2);
}

bool operator==(long long f1, frac f2)
{
	return frac(f1) == f2;
}
bool operator>(long long f1, frac f2)
{
	return frac(f1) > f2;
}
bool operator<(long long f1, frac f2)
{
	return frac(f1) < f2;
}
bool operator>=(long long f1, frac f2)
{
	return frac(f1) >= f2;
}
bool operator<=(long long f1, frac f2)
{
	return frac(f1) <= f2;
}
bool operator!=(long long f1, frac f2)
{
	return frac(f1) != f2;
}

bool operator==(frac f1, long long f2)
{
	return f1 == frac(f2);
}
bool operator>(frac f1, long long f2)
{
	return f1 > frac(f2);
}
bool operator<(frac f1, long long f2)
{
	return f1 < frac(f2);
}
bool operator>=(frac f1, long long f2)
{
	return f1 >= frac(f2);
}
bool operator<=(frac f1, long long f2)
{
	return f1 <= frac(f2);
}
bool operator!=(frac f1, long long f2)
{
	return f1 != frac(f2);
}

std::ostream& operator<<(std::ostream& out, frac f);
std::istream& operator>>(std::istream& in, frac& f);


std::wostream& operator<<(std::wostream& out, frac f);
std::wistream& operator>>(std::wistream& in, frac& f);

frac abs(frac f);
const int PASSO_MAX = 10;
const double ERR_MAX = 0.000001;
unsigned long long mcd(unsigned long long m, unsigned long long n)
{
	if (m != n)
	{
		if (m < n)	//devo scambiarli perchË m deve essere pi˘ grande
		{
			unsigned long long a = n;	//copio n in a
			n = m;	//sposto il valore di n in m
			m = a;	//e riscrivo il valore di n (che avevo copiato in a) in m
		}
		long long r = m % n;
		if (r != 0)
		{
			return mcd(r, n);
		}
		else
		{
			return n;
		}
	}
	return m;
}

unsigned long long mcm(unsigned long long m, unsigned long long n)
{
	if (m == 1)
	{
		return n;
	}
	if (n == 1)
	{
		return m;
	}
	if (m % n == 0)
	{
		return m;
	}
	if (n % m == 0)
	{
		return n;
	}
	unsigned long long mult_m = m;
	unsigned long long mult_n = n;
	while (mult_m != mult_n)
	{
		if (mult_m > mult_n)
		{
			mult_n += n * (mult_m / mult_n);
		}
		else
		{
			mult_m += m * (mult_n / mult_m);
		}
	}
	return mult_m;
}

unsigned long long rip(unsigned long long elem[3], unsigned long long& prod_1, unsigned long long new_)
{
	unsigned long long r = 0;
	prod_1 = elem[0];
	prod_1 += elem[1];
	if (prod_1 < elem[1])
		r++;
	prod_1 += elem[2];
	if (prod_1 < elem[2])
		r++;
	prod_1 += new_;
	if (prod_1 < new_)
		r++;
	return r;
}

unsigned long long take_bits(unsigned long long prima, unsigned long long seconda, int inizio, int fine)
{
	unsigned long long res = 0;
	if (inizio < 64)
	{
		prima = prima << inizio;
		prima = prima >> inizio;
		res += prima;

	}
	if (fine < 64)
	{
		res = res >> (63 - fine);
	}
	if (fine >= 64)
	{
		res = res << (fine - 63);
		res += seconda >> (127 - fine);
	}
	if (inizio > 64)
	{
		res = res << (128 - (inizio - fine - 1));
		res = res >> (128 - (inizio - fine - 1));
	}
	return res;
}

int floor(frac f)
{
	if (f.num >= 0)
		return f.num / f.den;
	else
		return -((int)((-f.num) / f.den)) - 1;
}

unsigned long long operazione_pericolosa(unsigned long long modulo, unsigned long long divided, unsigned long long new_)
{
	unsigned long long new_modulo = 0;

	unsigned long long modulo_2 = modulo >> 32;
	unsigned long long modulo_1 = modulo & 0x00000000FFFFFFFFull;

	unsigned long long divided_2 = divided >> 32;
	unsigned long long divided_1 = divided & 0x00000000FFFFFFFFull;

	unsigned long long m1d2 = modulo_1 * divided_2, m2d1 = modulo_2 * divided_1;

	unsigned long long prod_1_add[3];
	{
		prod_1_add[0] = modulo_1 * divided_1;
		prod_1_add[1] = m1d2 << 32;
		prod_1_add[2] = m2d1 << 32;
	}
	unsigned long long prod_1;
	unsigned long long prod_2 = rip(prod_1_add, prod_1, new_ / 2) + modulo_2 * divided_2 + (m1d2 >> 32) + (m2d1 >> 32);

	int first_1 = 1;
	while (new_ >> first_1)
		first_1++;

	unsigned long long tmp = take_bits(prod_2, prod_1, 0, 0 + first_1 - 1);
	for (int i = 0; i <= 128 - first_1; i++)
	{
		new_modulo = new_modulo << 1;
		if (tmp > new_)
		{
			new_modulo++;
			tmp -= new_;
		}
		tmp = tmp << 1;
		if (i + first_1 < 64)
			tmp += ((prod_2 >> (63 - (i + first_1))) & 0x1ull);
		else
			tmp += ((prod_1 >> (127 - (i + first_1))) & 0x1ull);
	}
	return new_modulo;
}

frac::frac(long long new_num, unsigned long long new_den)
{
	if (new_den == 0 && new_num != 0)
	{
		if (new_num > 0)
		{
			num = 1;
			den = 0;
		}
		else
		{
			num = -1;
			den = 0;
		}
		return;
	}

	if (new_num == 0 && new_den != 0)
	{
		num = 0;
		den = 1;
		return;
	}

	if (new_num == 0 && new_den == 0)
	{
		num = 0;
		den = 0;
		return;
	}

	bool meno = false;
	if (new_num < 0)
	{
		meno = true;
		new_num *= -1;
	}

	unsigned long long div = mcd(new_num, new_den);
	new_num /= div;
	new_den /= div;

	if (new_den <= UINT_MAX && new_num <= INT_MAX)
	{
		num = (int)new_num;
		den = (unsigned int)new_den;
		if (meno)
			num *= -1;
		return;
	}
	unsigned int rapp = (unsigned int)(new_den / UINT_MAX > (unsigned long long)new_num / INT_MAX ? new_den / UINT_MAX + 1 : new_num / INT_MAX + 1);
	if (new_num > new_den)
	{
		unsigned long long divided_den = new_den / (unsigned long long)rapp;
		if (divided_den == 0)
		{
			num = 1;
			den = 0;
			if (meno)
				num *= -1;
			return;
		}
		unsigned long long modulo = new_num % new_den;
		if ((modulo * divided_den) / divided_den == modulo)
			modulo = (modulo * divided_den + new_den / 2) / new_den;
		else
			modulo = operazione_pericolosa(modulo, divided_den, new_den);
		new_num = (new_num / new_den) * divided_den + modulo;
		*this = frac(new_num, divided_den);
		if (meno)
			num *= -1;
	}
	else
	{
		unsigned long long divided_num = new_num / (unsigned long long)rapp;
		if (divided_num == 0)
		{
			num = 0;
			den = 1;
			return;
		}
		unsigned long long modulo = new_den % new_num;
		if ((modulo * divided_num) / divided_num == modulo)
			modulo = (modulo * divided_num + new_num / 2) / new_num;
		else
			modulo = operazione_pericolosa(modulo, divided_num, new_num);
		new_den = (new_den / new_num) * divided_num + modulo;
		*this = frac((long long)divided_num, new_den);
		if (meno)
			num *= -1;
	}
}

frac::frac(long double val, int passo_n)
{
	long long val_intero = (long long)(val);
	long double val_frazionario = val - double(val_intero);
	long long new_num;
	unsigned long long new_den;
	if (val_frazionario < ERR_MAX || passo_n > PASSO_MAX)
	{
		new_num = val_intero;
		new_den = 1;
	}
	else
	{
		frac f = frac(val_intero) + (frac(1) / frac(1.0 / val_frazionario, passo_n + 1));
		new_num = f.num;
		new_den = f.den;
	}
	*this = frac(new_num, new_den);
}
frac::frac(long double val)
{
	if (val > (long double)INT_MAX)
	{
		num = 1;
		den = 0;
		return;
	}
	if (val < (long double)INT_MIN)
	{
		num = -1;
		den = 0;
		return;
	}
	if (val != val)
	{
		num = 0;
		den = 0;
		return;
	}
	bool meno = false;
	if (val < 0)
	{
		meno = true;
		val *= -1;
	}
	long long new_num;
	unsigned long long new_den;
	long long val_intero = (long long)(val);
	long double val_frazionario = val - (long double)(val_intero);
	if (val_frazionario == 0)
	{
		new_num = val_intero;
		new_den = 1;
	}
	else
	{
		frac f = frac(val_intero) + (frac(1) / frac(1.0 / val_frazionario, 1));
		new_num = f.num;
		new_den = f.den;
		if (meno)
		{
			new_num *= -1;
		}
	}
	*this = frac(new_num, new_den);
}

frac operator+(frac f1, frac f2)
{
	if (f1.den != 0 && f2.den != 0)
	{
		unsigned long long new_den;
		long long new_num;

		if (f2.den == f1.den)
			new_den = (unsigned long long)f1.den;
		else
			new_den = (unsigned long long)f1.den * (unsigned long long)f2.den;

		new_num = (f1.num) * (new_den / f1.den) + (f2.num) * (new_den / f2.den);
		return frac(new_num, new_den);
	}
	if (f1.den == 0 && f2.den != 0)
	{
		return f1;
	}
	if (f1.den != 0 && f2.den == 0)
	{
		return f2;
	}

	if (f1.num > 0 && f2.num > 0 || f1.num < 0 && f2.num < 0)
	{
		return f1;
	}
	if (f1.num < 0 && f2.num > 0 || f1.num > 0 && f2.num < 0 || f1.num == 0 && f2.num == 0)
	{
		return frac(0ll, 0ull);
	}
	else if (f1.num == 0 && f2.num != 0)
	{
		return f2;
	}
	else if (f1.num != 0 && f2.num == 0)
	{
		return f1;
	}
	return f1;
}

frac operator-(frac f1, frac f2)
{
	return f1 + (-f2);
}

frac operator*(frac f1, frac f2)
{
	unsigned long long new_den = (unsigned long long)f1.den * (unsigned long long)f2.den;
	long long new_num = (long long)f1.num * (long long)f2.num;
	return frac(new_num, new_den);
}

frac operator/(frac f1, frac f2)
{
	long long new_den = (long long)f1.den * (long long)f2.num;
	long long new_num = (long long)f1.num * (long long)f2.den;
	if (new_den < 0)
	{
		new_den *= -1;
		new_num *= -1;
	}
	return frac(new_num, (unsigned long long)new_den);
}

bool operator ==(frac f1, frac f2)
{
	if (f1.den == 0 || f2.den == 0)
		return false;

	if (f1.num == f2.num && f1.den == f2.den)
		return true;

	return false;
}
bool operator >(frac f1, frac f2)
{
	if (f1.den != 0 || f2.den != 0)
	{
		long long first = (long long)f1.num * (long long)f2.den;
		long long second = (long long)f2.num * (long long)f1.den;
		return (first > second);
	}
	return false;
}
bool operator <(frac f1, frac f2)
{
	if (f1.den != 0 || f2.den != 0)
	{
		long long first = (long long)f1.num * (long long)f2.den;
		long long second = (long long)f2.num * (long long)f1.den;
		return (first < second);
	}
	return false;
}
bool operator >=(frac f1, frac f2)
{
	if (f1.den != 0 && f2.den != 0 && f1.den == f2.den && f1.num == f2.num)
		return true;
	if (f1.den != 0 || f2.den != 0)
	{
		long long first = (long long)f1.num * (long long)f2.den;
		long long second = (long long)f2.num * (long long)f1.den;
		return (first > second);
	}
	return false;
}
bool operator <=(frac f1, frac f2)
{
	if (f1.den != 0 && f2.den != 0 && f1.den == f2.den && f1.num == f2.num)
		return true;
	if (f1.den != 0 || f2.den != 0)
	{
		long long first = (long long)f1.num * (long long)f2.den;
		long long second = (long long)f2.num * (long long)f1.den;
		return (first < second);
	}
	return false;
}
bool operator !=(frac f1, frac f2)
{
	if (f1.den == 0 || f2.den == 0)
		return true;

	if (f1.num == f2.num && f1.den == f2.den)
		return false;

	return true;
}

std::ostream & operator<<(std::ostream& out, frac f)
{
	if (f.den == 0)
	{
		if (f.num == 0)
			out << "nan";
		else
		{
			if (f.num > 0)
				out << "inf";
			else
				out << "-inf";
		}
		return out;
	}
	if (f.den == 1)
	{
		out << f.num;
		return out;
	}
	out << f.num << '/' << f.den;
	return out;
}

long double get_decimal_part(long long int_part, std::istream& in)
{
	in.ignore();
	long double val = (long double)(int_part);
	long double mult = 0.1;
	while (in.peek() >= '0' && in.peek() <= '9')
	{
		int digit = in.get() - '0';
		val += (long double)digit * mult;
		mult /= 10.;
		in.ignore();
	}
	if (in.peek() == 'e' || in.peek() == 'E')
	{
		in.ignore();
		int exp;
		if (in >> exp)
		{
			while (exp > 0)
			{
				val *= 10.;
				exp--;
			}
			while (exp < 0)
			{
				val /= 10.;
				exp++;
			}
		}
	}
	return val;
}

std::istream& operator>>(std::istream& in, frac& f)
{
	bool meno;
	long long num;
	long long den;
	double frac_part;
	while (in.peek() == ' ' || in.peek() == '\t' || in.peek() == '\n')
		in.ignore(1);
	if (in.peek() == '-')
	{
		meno = true;
		in.ignore(1);
		if (in.peek() == '-')
		{
			in.fail();
			f = frac(0, 0);
			return in;
		}
	}
	else
		meno = false;
	if (in.peek() == '.')
		num = 0;
	else
		in >> num;
	if (in.peek() == '.')
	{
		if (in.peek() == '-')
		{
			in.fail();
			f = frac(0, 0);
			return in;
		}
		in >> frac_part;
		f = (double)(num + frac_part);
	}
	else if (in.peek() == '/')
	{
		in.ignore(1);
		if (in.peek() == '-')
		{
			meno = true;
			in.ignore(1);
		}
		in >> den;
		f.num = num;
		f.den = den;
	}
	else
	{
		f.num = num;
		f.den = 1;
	}
	if (meno)
		f.num = -f.num;
	f = frac(f.num, f.den);
	return in;
}

std::wostream& operator<<(std::wostream& out, frac f)
{
	if (f.den == 0)
	{
		if (f.num == 0)
			out << L"nan";
		else
		{
			if (f.num > 0)
				out << L"inf";
			else
				out << L"-inf";
		}
		return out;
	}
	if (f.den == 1)
	{
		out << f.num;
		return out;
	}
	out << f.num << L'/' << f.den;
	return out;
}

std::wistream& operator>>(std::wistream& in, frac& f)
{
	bool meno;
	long long num;
	long long den;
	double frac_part;
	while (in.peek() == L' ' || in.peek() == L'\t' || in.peek() == L'\n')
		in.ignore(1);
	if (in.peek() == L'-')
	{
		meno = true;
		in.ignore(1);
		if (in.peek() == L'-')
		{
			in.fail();
			f = frac(0, 0);
			return in;
		}
	}
	else
		meno = false;
	if (in.peek() == L'.')
		num = 0;
	else
		in >> num;
	if (in.peek() == L'.')
	{
		if (in.peek() == L'-')
		{
			in.fail();
			f = frac(0, 0);
			return in;
		}
		in >> frac_part;
		f = (double)(num + frac_part);
	}
	else if (in.peek() == L'/')
	{
		in.ignore(1);
		if (in.peek() == L'-')
		{
			meno = true;
			in.ignore(1);
		}
		in >> den;
		f.num = num;
		f.den = den;
	}
	else
	{
		f.num = num;
		f.den = 1;
	}
	if (meno)
		f.num = -f.num;
	f = frac(f.num, f.den);
	return in;
}

frac abs(frac f)
{
	if (f.num < 0)
		f.num *= -1;
	return f;
}

namespace std {
	template<> class numeric_limits<frac> {
	public:
		static frac max()
		{ 
			return frac(1, 0);
		}
		static frac min()
		{
			return frac(-1, 0);
		}
	};
}

template<typename t> class vet
{
	t* data;
	unsigned int len;
	unsigned int spacing = 1;
	bool nodel = false;
	vet(t* v, unsigned int length, unsigned int sp = 1)
	{
		len = length;
		data = v;
		nodel = true;
		spacing = sp;
	}
public:
	void resize(unsigned int new_size)
	{
		if (nodel)
		{
			cerr << "error: cannot resize an editable row/column vector" << endl;
			return;
		}
		t* data2 = new t[new_size];
		for (unsigned int i = 0; i < len; i++)
		{
			if (i >= new_size)
				break;
			data2[i * spacing] = data[i * spacing];
		}
		if (data != nullptr)
			delete[] data;
		len = new_size;
		data = data2;
	}

	void delete_elem(unsigned int j)
	{
		if (nodel)
		{
			cerr << "error: cannot resize an editable row/column vector" << endl;
			return;
		}
		t* data2 = new t[len - 1];
		for (unsigned int i = 0; i < len - 1; i++)
		{
			if(i < j)
				data2[i * spacing] = data[i * spacing];
			else
				data2[i * spacing] = data[(i + 1) * spacing];
		}
		if (data != nullptr)
			delete[] data;
		len = len - 1;
		data = data2;
	}

	unsigned int size() const
	{
		return len;
	}

	void xcgh_elems(unsigned int i, unsigned int ii)
	{
		t x = (*this)[ii];
		(*this)[ii] = (*this)[i];
		(*this)[i] = x;
	}

	void sum_elems(unsigned int i, unsigned int ii, t multiplier) //riga ii = riga ii + riga i
	{
		(*this)[ii] += (*this)[i] * (t)multiplier;
		if ((*this)[ii] < 0.00000000001 && (*this)[ii] > -0.00000000001)
			(*this)[ii] = 0;
	}

	vet<t> operator-()
	{
		vet<t> res(len);
		for (unsigned int i = 0; i < len; i++)
			res[i] = -(*this)[i];
		return res;
	}

	vet<t> operator-(const vet<t>& v2) const
	{
		if (len != v2.len)
		{
			cerr << "error: vector sizes are different!" << endl;
			return vet<t>(0);
		}
		vet<t> res(len);
		for (unsigned int i = 0; i < len; i++)
			res[i] = (*this)[i] - v2[i];
		return res;
	}
	vet<t> operator^(const vet<t>& v2) const
	{
		if (len != 3 || v2.len != 3)
		{
			cerr << "error: vector must be of size 3!" << endl;
			return vet<t>(3);
		}
		vet<t> res(3);
		res[0] = (*this)[1] * v2[2] - (*this)[2] * v2[1];
		res[1] = -(*this)[0] * v2[2] + (*this)[2] * v2[0];
		res[2] = (*this)[0] * v2[1] - (*this)[1] * v2[0];
		return res;
	}
	t operator*(const vet<t>& v2) const
	{
		if (len != v2.len)
		{
			cerr << "error: vector sizes are different!" << endl;
			return 0;
		}
		t res = 0;
		for (unsigned int i = 0; i < len; i++)
			res += v2[i] * (*this)[i];

		if (res < 0.00000000001 && res > -0.00000000001)
			res = 0;

		return res;
	}
	bool operator>=(const vet<t>& v2) const
	{
		if (len != v2.len)
		{
			cerr << "error: vector sizes are different!" << endl;
			return false;
		}
		for (unsigned int i = 0; i < len; i++)
			if (!((*this)[i] >= v2[i]))
				return false;
		return true;
	}
	bool operator<=(const vet<t>& v2) const
	{
		if (len != v2.len)
		{
			cerr << "error: vector sizes are different!" << endl;
			return false;
		}
		for (unsigned int i = 0; i < len; i++)
			if (!((*this)[i] <= v2[i]))
				return false;
		return true;
	}
	bool operator>(const vet<t>& v2) const
	{
		if (len != v2.len)
		{
			cerr << "error: vector sizes are different!" << endl;
			return false;
		}
		for (unsigned int i = 0; i < len; i++)
			if (!((*this)[i] > v2[i]))
				return false;
		return true;
	}
	bool operator<(const vet<t>& v2) const
	{
		if (len != v2.len)
		{
			cerr << "error: vector sizes are different!" << endl;
			return false;
		}
		for (unsigned int i = 0; i < len; i++)
			if (!((*this)[i] < v2[i]))
				return false;
		return true;
	}
	bool operator!=(const vet<t>& v2) const
	{
		if (len != v2.len)
		{
			cerr << "error: vector sizes are different!" << endl;
			return true;
		}
		for (unsigned int i = 0; i < len; i++)
			if ((*this)[i] != v2[i])
				return true;
		return false;
	}
	bool operator==(const vet<t>& v2) const
	{
		if (len != v2.len)
		{
			cerr << "error: vector sizes are different!" << endl;
			return false;
		}
		for (unsigned int i = 0; i < len; i++)
			if ((*this)[i] != v2[i])
				return false;
		return true;
	}
	vet<t>& operator/=(t k)
	{
		for (unsigned int i = 0; i < len; i++)
			(*this)[i] = (*this)[i] / k;
		return *this;
	}
	vet<t>& operator*=(t k)
	{
		for (unsigned int i = 0; i < len; i++)
			(*this)[i] = (*this)[i] * k;
		return *this;
	}
	vet<t>& operator-=(const vet<t>& v2)
	{
		if (len != v2.len)
		{
			cerr << "error: vector sizes are different!" << endl;
			return *this;
		}
		for (unsigned int i = 0; i < len; i++)
			(*this)[i] = (*this)[i] - v2[i];
		return *this;
	}
	vet<t>& operator+=(const vet<t>& v2)
	{
		if (len != v2.len)
		{
			cerr << "error: vector sizes are different!" << endl;
			return *this;
		}
		for (unsigned int i = 0; i < len; i++)
			(*this)[i] = (*this)[i] + v2[i];
		return *this;
	}
	vet<t> operator+(const vet<t>& v2) const
	{
		if (len != v2.len)
		{
			cerr << "error: vector sizes are different!" << endl;
			return vet<t>(0);
		}
		vet<t> res(len);
		for (unsigned int i = 0; i < len; i++)
			res[i] = (*this)[i] + v2[i];
		return res;
	}
	t operator[](unsigned int i) const
	{
		if (i >= len)
			cerr << "error: out of bounds" << endl;
		return data[i * spacing];
	}
	t& operator[](unsigned int i)
	{
		if (i >= len)
			cerr << "error: out of bounds" << endl;
		return data[i * spacing];
	}
	vet<t>& operator=(const vet<t>& v2)
	{
		if (this == &v2)
			return *this;
		if (v2.nodel)
		{
			if (!nodel && data != nullptr)
				delete[] data;
			if (v2.len != len)
				cerr << "warning: changed vector size" << endl;
			data = v2.data;
			return *this;
		}
		if (len == v2.len)
			for (unsigned int i = 0; i < len; i++)
			{
				(*this)[i] = v2[i];
			}
		else
		{
			if (data != nullptr)
			{
				if (!nodel)
				{
					delete[] data;
					cerr << "warning: changed vector size" << endl;
				}
				else
				{
					cerr << "error: cannot delete an editable row/column vector" << endl;
					return *this;
				}
			}
			len = v2.len;
			data = new t[len];
			for (unsigned int i = 0; i < len; i++)
			{
				(*this)[i] = v2[i];
			}
		}
		return *this;
	}
	vet<t>& operator=(char ch)
	{
		if (ch != '0')
		{
			cerr << "error: initializer is not valid" << endl;
			return *this;
		}
		if (len == 0)
			return *this;
		for (unsigned int i = 0; i < len; i++)
			(*this)[i] = 0;
		return *this;
	}
	vet(const vet<t>& v)
	{
		len = v.len;
		if (v.nodel)
		{
			data = v.data;
			return;
		}
		if (len != 0)
		{
			data = new t[len];
			for (unsigned int i = 0; i < len; i++)
			{
				(*this)[i] = v[i];
			}
		}
		else
			data = nullptr;
	}
	vet(char c, unsigned int l)
	{
		len = l;
		if (l > 0)
			data = new t[l];
		else
			data = nullptr;
		if (c != '0')
		{
			cerr << "error: initializer not valid" << endl;
		}
		for (unsigned int i = 0; i < l; i++)
			(*this)[i] = 0;
	}
	vet(unsigned int length, t* v)
	{
		len = length;
		if (length > 0)
			data = new t[length];
		else
			data = nullptr;
		for (unsigned int i = 0; i < length; i++)
		{
			(*this)[i] = v[i];
		}
	}
	explicit vet(unsigned int length)
	{
		len = length;
		if (length > 0)
			data = new t[length];
		else
			data = nullptr;
	}
	vet()
	{
		data = nullptr;
		len = 0;
	}
	~vet()
	{
		if (data != nullptr && !nodel)
			delete[] data;
	}
	template <typename t2>
	friend ostream& operator<<(ostream&, const vet<t2>&);

	template <typename t2>
	friend istream& operator>>(istream&, vet<t2>&);

	template <typename t2>
	friend vet<t2> operator*(t2, const vet<t2>&);

	template <typename t2>
	friend vet<t2> operator*(const vet<t2>&, t2);

	template <typename t2>
	friend vet<t2> operator/(const vet<t2>&, t2);

	template <typename t2>
	friend class mat;
};

template <typename t>
ostream& operator<<(ostream& out, const vet<t>& v)
{
	out << '[';
	for (unsigned int i = 0; i < v.len; i++)
	{
		if (i != 0)
			out << ", ";
		out << v[i];
	}
	out << ']';
	return out;
}

template <typename t>
struct elem
{
	elem<t>* next;
	t data;
	elem(t d, elem<t>* n = nullptr)
	{
		data = d;
		next = n;
	}
};

template <typename t>
class datalist
{
	elem<t>* first;
	elem<t>* last;
	unsigned int num;
public:
	int n()
	{
		return num;
	}
	datalist()
	{
		first = nullptr;
		last = nullptr;
		num = 0;
	}
	void add(t data)
	{
		num++;
		if (first == nullptr)
		{
			first = new elem<t>(data);
			last = first;
			return;
		}
		last->next = new elem<t>(data);
		last = last->next;
	}
	t read()
	{
		num--;
		if (first == nullptr)
		{
			cerr << "error: list is empty" << endl;
			return t(0);
		}
		t var = first->data;

		elem<t>* e = first->next;
		delete first;
		first = e;
		if (first == nullptr)
			last = nullptr;
		return var;
	}
	~datalist()
	{
		while (first != nullptr)
		{
			elem<t>* e = first->next;
			delete first;
			first = e;
		}
	}
};

template <typename t>
istream& operator>>(istream& in, vet<t>& v)
{
	while (in.peek() == ' ' || in.peek() == '\t' || in.peek() == '\n')
		in.ignore(1);
	if (in.peek() != '[')
	{
		in.fail();
		return in;
	}
	in.ignore(1);

	while (in.peek() == ' ' || in.peek() == '\t' || in.peek() == '\n')
		in.ignore(1);

	if (v.len == 0)
	{
		if (in.peek() == ']')
		{
			in.ignore(1);
			return in;
		}
		datalist<t> l;

		while (true)
		{
			t var;
			cin >> var;
			l.add(var);

			if (in.peek() == ']')
			{
				in.ignore(1);
				v.data = new t[l.n()];
				v.len = l.n();
				int i = 0;
				while (l.n() != 0)
				{
					v.data[i++] = l.read();
				}
				return in;
			}
			if (in.peek() != ',')
			{
				in.fail();
				return in;
			}
			in.ignore(1);
			if (in.peek() == ' ')
				in.ignore(1);
		}
	}
	for (unsigned int i = 0; i < v.len; i++)
	{
		cin >> v[i];
		if (i == v.len - 1)
			break;
		if (in.peek() != ',')
		{
			in.fail();
			return in;
		}
		in.ignore(1);
		if (in.peek() == ' ')
			in.ignore(1);

	}
	if (in.peek() != ']')
		in.fail();
	else
		in.ignore(1);
	return in;
}

template <typename t>
vet<t> operator*(t k, const vet<t>& v)
{
	vet<t> res(v.len);
	for (unsigned int i = 0; i < v.len; i++)
	{
		res[i] = v[i] * k;
	}
	return res;
}

template <typename t>
vet<t> operator*(const vet<t>& v, t k)
{
	vet<t> res(v.len);
	for (unsigned int i = 0; i < v.len; i++)
	{
		res[i] = v[i] * k;
	}
	return res;
}

template <typename t>
vet<t> operator/(const vet<t>& v, t k)
{
	vet<t> res(v.len);
	for (unsigned int i = 0; i < v.len; i++)
	{
		res[i] = v[i] / k;
	}
	return res;
}

template<typename t> class mat
{
	t* data;
	unsigned int rows;
	unsigned int cols;
public:
	unsigned int n_cols()
	{
		return cols;
	}
	unsigned int n_rows()
	{
		return rows;
	}
	void resize_cols(unsigned int new_cols)
	{
		t* data2 = new t[new_cols * rows];
		for (unsigned int i = 0; i < rows; i++)
		{
			for (unsigned int ii = 0; ii < cols; ii++)
			{
				if (ii >= new_cols)
					break;
				data2[i * new_cols + ii] = data[i * cols + ii];
			}
		}
		if (data != nullptr)
			delete[] data;
		cols = new_cols;
		data = data2;
	}
	void resize_rows(unsigned int new_rows)
	{
		t* data2 = new t[cols * new_rows];
		for (unsigned int i = 0; i < rows * cols; i++)
		{
			if (i >= new_rows * cols)
				break;
			data2[i] = data[i];
		}
		if (data != nullptr)
			delete[] data;
		rows = new_rows;
		data = data2;
	}
	void delete_row(unsigned int i)
	{
		for (unsigned int j = i; j < rows - 1; j++)
		{
			row_reference(j) = row(j + 1);
		}
		resize_rows(rows - 1);
	}
	void delete_col(unsigned int i)
	{
		for (unsigned int j = i; j < cols - 1; j++)
		{
			col_reference(j) = col(j + 1);
		}
		resize_cols(cols - 1);
	}
	void xcgh_cols(unsigned int i, unsigned int ii)
	{
		vet<t> v = col(ii);
		col_reference(ii) = col(i);
		col_reference(i) = v;
	}
	void xcgh_rows(unsigned int i, unsigned int ii)
	{
		vet<t> v = row(ii);
		row_reference(ii) = row(i);
		row_reference(i) = v;
	}
	void sum_cols(unsigned int i, unsigned int ii, t multiplier) //riga ii = riga ii + riga i
	{
		col_reference(ii) += (vet<t>)col_reference(i) * (t)multiplier;
		for (unsigned int i = 0; i < cols; i++)
		{
			if (col_reference(ii)[i] < 0.00000000001 && col_reference(ii)[i] > -0.00000000001)
				col_reference(ii)[i] = 0;
		}
	}
	void sum_rows(unsigned int i, unsigned int ii, t multiplier) //riga ii = riga ii + riga i
	{
		row_reference(ii) += (vet<t>)row_reference(i) * (t)multiplier;
		for (unsigned int i = 0; i < cols; i++)
		{
			if (row_reference(ii)[i] < 0.00000000001 && row_reference(ii)[i] > -0.00000000001)
				row_reference(ii)[i] = 0;
		}
	}
	t det()
	{
		if (cols != rows)
		{
			cerr << "error: the matrix is not a square matrix" << endl;
			return 0;
		}
		mat<t> m = (*this);
		mat<t> m2(cols);
		m2 = 'I';
		bool sign = false;
		for (unsigned int i = 0; i < cols; i++)
		{
			if (m.data[i * cols + i] == 0)
			{
				for (unsigned int j = i + 1; j < rows; j++)
				{
					if (m.data[i * cols + j] != 0)
					{
						m.xcgh_rows(i, j);
						sign = !sign;
						m2.xcgh_rows(i, j);
						break;
					}
				}
			}
			if (m.data[i * cols + i] == 0)
				return 0;
			for (unsigned int j = i + 1; j < rows; j++)
			{
				t rapp = -m.data[j * cols + i] / m.data[i * cols + i];
				m.sum_rows(i, j, rapp);
				m2.sum_rows(i, j, rapp);
			}
		}
		t det = 1;
		for (unsigned int i = 0; i < cols; i++)
		{
			det *= m[i][i];
		}
		if (sign)
			det = -det;
		return det;
	}
	mat<t> inv()
	{
		if (cols != rows)
		{
			cerr << "error: the matrix is not a square matrix" << endl;
			return mat<t>(0);
		}
		mat<t> m = (*this);
		mat<t> m2(cols);
		m2 = 'I';
		if (m2.cols == 0)
			return m2;
		if (m2.cols == 1)
		{
			m2.data[0] = 1 / m.data[0];
			return m2;
		}
		for (unsigned int i = 0; i < cols; i++)
		{
			if (m.data[i * cols + i] == 0)
			{
				for (unsigned int j = i + 1; j < rows; j++)
				{
					if (m.data[i * cols + j] != 0)
					{
						m.xcgh_rows(i, j);
						m2.xcgh_rows(i, j);
						break;
					}
				}
			}
			if (m.data[i * cols + i] == 0)
			{
				cerr << "error: determinant is 0" << endl;
				return mat<t>(0);
			}
			for (unsigned int j = i + 1; j < rows; j++)
			{
				t rapp = -m.data[j * cols + i] / m.data[i * cols + i];
				m.sum_rows(i, j, rapp);
				m2.sum_rows(i, j, rapp);
			}
			t rowdiv = m[i][i];
			m.row_reference(i) /= rowdiv;
			m2.row_reference(i) /= rowdiv;
		}

		for (unsigned int i = cols - 1; i <= cols; i--)
		{
			for (unsigned int j = i - 1; j <= cols; j--)
			{
				m2.sum_rows(i, j, -m[j][i]);
			}
		}
		return m2;
	}
	unsigned int rank()
	{
		mat<t> m = (*this);
		for (unsigned int i = 0; i < rows; i++)
		{
			if (m.data[i * cols + i] == 0)
			{
				for (unsigned int j = i + 1; j < rows; j++)
				{
					if (m.data[i * cols + j] != 0)
					{
						m.xcgh_rows(i, j);
						break;
					}
				}
			}
			if (m.data[i * cols + i] == 0)
			{
				return i;
			}
			for (unsigned int j = i + 1; j < rows; j++)
			{
				t rapp = -m.data[j * cols + i] / m.data[i * cols + i];
				m.sum_rows(i, j, rapp);
			}
		}
		cout << m;
		return rows;
	}
	mat<t> transp()
	{
		mat<t> res(cols, rows);
		for (unsigned int i = 0; i < rows; i++)
		{
			for (unsigned int j = 0; j < cols; j++)
			{
				res.data[i + j * rows] = data[i * cols + j];
			}
		}
		return res;
	}
	void resize(unsigned int new_rows, unsigned int new_cols)
	{
		t* data2 = new t[new_cols * new_rows];
		for (unsigned int i = 0; i < rows; i++)
		{
			if (i >= new_rows)
				break;
			for (unsigned int ii = 0; ii < cols; ii++)
			{
				if (ii >= new_cols)
					break;
				data2[i * new_cols + ii] = data[i * cols + ii];
			}
		}
		if (data != nullptr)
			delete[] data;
		cols = new_cols;
		rows = new_rows;
		data = data2;
	}
	mat<t> operator-()
	{
		mat<t> res(rows, cols);
		for (unsigned int i = 0; i < rows * cols; i++)
			res.data[i] = -data[i];
		return res;
	}

	mat<t> operator-(const mat<t>& m2)
	{
		if (rows != m2.rows || cols != m2.cols)
		{
			cerr << "error: matrix sizes are different!" << endl;
			return mat<t>(0);
		}
		mat<t> res(rows, cols);
		for (unsigned int i = 0; i < rows * cols; i++)
			res.data[i] = data[i] - m2.data[i];
		return res;
	}

	bool operator!=(const mat<t>& m2) const
	{
		if (cols != m2.cols || rows != m2.rows)
		{
			cerr << "error: matrix sizes are different!" << endl;
			return true;
		}
		for (unsigned int i = 0; i < cols * rows; i++)
			if (data[i] != m2.data[i])
				return true;
		return false;
	}
	bool operator==(const mat<t>& m2) const
	{
		if (cols != m2.cols || rows != m2.rows)
		{
			cerr << "error: matrix sizes are different!" << endl;
			return false;
		}
		for (unsigned int i = 0; i < cols * rows; i++)
			if (data[i] != m2.data[i])
				return false;
		return true;
	}
	operator vet<t>() const
	{
		vet<t> res(cols * rows);
		for (unsigned int i = 0; i < cols * rows; i++)
		{
			res.data[i] = data[i];
		}
		return res;
	}
	mat<t>& operator/=(t k)
	{
		for (unsigned int i = 0; i < cols * rows; i++)
			data[i] = data[i] / k;
		return *this;
	}
	mat<t>& operator*=(t k)
	{
		for (unsigned int i = 0; i < cols * rows; i++)
			data[i] = data[i] * k;
		return *this;
	}
	mat<t>& operator-=(const mat<t>& m2)
	{
		if (cols != m2.cols || rows != m2.rows)
		{
			cerr << "error: matrix sizes are different!" << endl;
			return *this;
		}
		for (unsigned int i = 0; i < cols * rows; i++)
			data[i] = data[i] - m2.data[i];
		return *this;
	}
	mat<t>& operator+=(const mat<t>& m2)
	{
		if (cols != m2.cols || rows != m2.rows)
		{
			cerr << "error: matrix sizes are different!" << endl;
			return *this;
		}
		for (unsigned int i = 0; i < cols * rows; i++)
			data[i] = data[i] + m2.data[i];
		return *this;
	}
	mat<t> operator+(const mat<t>& m2) const
	{
		if (cols != m2.cols || rows != m2.rows)
		{
			cerr << "error: matrix sizes are different!" << endl;
			return mat<t>(0);
		}
		mat<t> res(rows, cols);
		for (unsigned int i = 0; i < cols * rows; i++)
			res.data[i] = data[i] + m2.data[i];
		return res;
	}
	const vet<t> operator[](unsigned int i) const
	{
		if (i >= rows)
			cerr << "error: out of bounds" << endl;
		return vet<t>(&data[i * cols], cols);
	}
	vet<t> operator[](unsigned int i)
	{
		if (i >= rows)
			cerr << "error: out of bounds" << endl;
		return vet<t>(&data[i * cols], cols);
	}
	vet<t> row(unsigned int i) const
	{
		if (i >= rows)
			cerr << "error: out of bounds" << endl;
		return vet<t>(cols, &data[i * cols]);
	}
	vet<t> row_reference(unsigned int i)
	{
		if (i >= rows)
			cerr << "error: out of bounds" << endl;
		return vet<t>(&data[i * cols], cols);
	}
	vet<t> col(unsigned int i) const
	{
		if (i >= cols)
			cerr << "error: out of bounds" << endl;
		vet<t> v(rows);
		for (unsigned int j = 0; j < rows; j++)
		{
			v[j] = data[j * cols + i];
		}
		return v;
	}
	vet<t> col_reference(unsigned int i)
	{
		if (i >= cols)
			cerr << "error: out of bounds" << endl;
		return vet<t>(&data[i], rows, cols);
	}
	mat<t>& operator=(const mat<t>& m2)
	{
		if (this == &m2)
			return *this;
		if (rows == m2.rows && cols == m2.cols)
			for (unsigned int i = 0; i < cols * rows; i++)
			{
				data[i] = m2.data[i];
			}
		else
		{
			if (data != nullptr)
			{
				delete[] data;
				cerr << "warning: changed matrix size" << endl;
			}
			rows = m2.rows;
			cols = m2.cols;
			data = new t[rows * cols];
			for (unsigned int i = 0; i < rows * cols; i++)
			{
				data[i] = m2.data[i];
			}
		}
		return *this;
	}
	mat<t>& operator=(char ch)
	{
		if (ch != '0' && ch != 'I' && ch != 'i')
		{
			cerr << "error: initializer is not valid" << endl;
			return *this;
		}
		if (data == nullptr)
			return *this;
		if (ch == 0)
		{
			for (unsigned int i = 0; i < cols * rows; i++)
				data[i] = 0;
			return *this;
		}
		for (unsigned int i = 0; i < rows; i++)
		{
			for (unsigned int j = 0; j < cols; j++)
			{
				if (i == j)
					data[i * cols + j] = 1;
				else
					data[i * cols + j] = 0;
			}
		}
		return *this;
	}
	mat(const vet<t>& v)
	{
		rows = v.len;
		cols = 1;
		if (rows != 0)
		{
			data = new t[rows];
			for (unsigned int i = 0; i < rows; i++)
				data[i] = v.data[i];
		}
	}
	mat(char ch, int r, int c = 0)
	{
		if (c == 0)
			c = r;
		cols = (unsigned int)c;
		rows = (unsigned int)r;
		if (cols * rows != 0)
			data = new t[cols * rows];
		else
			data = nullptr;
		if (ch != '0' && ch != 'I' && ch != 'i')
		{
			cerr << "error: initializer is not valid" << endl;
		}
		if (ch == '0')
		{
			for (unsigned int i = 0; i < cols * rows; i++)
				data[i] = 0;
		}
		else
		{
			for (unsigned int i = 0; i < rows; i++)
			{
				for (unsigned int j = 0; j < cols; j++)
				{
					if (i == j)
						data[i * cols + j] = 1;
					else
						data[i * cols + j] = 0;
				}
			}
		}
	}
	mat(const mat<t>& m)
	{
		rows = m.rows;
		cols = m.cols;
		if (cols * rows != 0)
		{
			data = new t[rows * cols];
			for (unsigned int i = 0; i < rows * cols; i++)
			{
				data[i] = m.data[i];
			}
		}
		else
			data = nullptr;
	}
	mat(int r, int c = 0)
	{
		if (c == 0)
			c = r;
		rows = (unsigned int)r;
		cols = (unsigned int)c;
		if (rows * cols > 0)
			data = new t[rows * cols];
		else
			data = nullptr;
	}
	mat(unsigned int r, unsigned int c = 0)
	{
		if (c == 0)
			c = r;
		rows = r;
		cols = c;
		if (rows * cols > 0)
			data = new t[rows * cols];
		else
			data = nullptr;
	}
	mat()
	{
		data = nullptr;
		rows = 0;
		cols = 0;
	}
	~mat()
	{
		if (data != nullptr)
			delete[] data;
	}
	template <typename t2>
	friend ostream& operator<<(ostream&, const mat<t2>&);

	template <typename t2>
	friend istream& operator>>(istream&, mat<t2>&);

	template <typename t2>
	friend mat<t2> operator*(const mat<t2>&, const mat<t2>&);

	template <typename t2>
	friend vet<t2> operator*(const vet<t2>&, const mat<t2>&);

	template <typename t2>
	friend vet<t2> operator*(const mat<t2>&, const vet<t2>&);

	template <typename t2>
	friend mat<t2> operator*(t2, const mat<t2>&);

	template <typename t2>
	friend mat<t2> operator*(const mat<t2>&, t2);

	template <typename t2>
	friend mat<t2> operator/(const mat<t2>&, t2);

	template <typename t2>
	friend void simplify_col_system(mat<t2>&, vet<t2>&, bool& impossible);

	template <typename t2>
	friend void simplify_row_system(mat<t2>&, vet<t2>&, bool& impossible);
};

template <typename t>
void simplify_col_system(mat<t>& m, vet<t>& v, bool& impossible)
{
	impossible = false;
	for (unsigned int i = 0; i < m.cols; i++)
	{
		if (m.data[i * m.cols + i] == 0)
		{
			for (unsigned int j = i + 1; j < m.cols; j++)
			{
				if (m.data[j * m.cols + i] != 0)
				{
					m.xcgh_cols(i, j);
					v.xcgh_elems(i, j);
					break;
				}
			}
		}
		if (m.data[i * m.cols + i] == 0)
		{
			unsigned int j = i;
			for (; i < m.cols; i++)
			{
				if (v[i] != 0)
					impossible = true;
			}
			m.resize_cols(j);
			v.resize(j);
			return;
		}
		for (unsigned int j = i + 1; j < m.cols; j++)
		{
			t rapp = -m.data[i * m.cols + j] / m.data[i * m.cols + i];
			m.sum_cols(i, j, rapp);
			v.sum_elems(i, j, rapp);
		}
	}
}

template <typename t>
void simplify_row_system(mat<t>& m, vet<t>& v, bool& impossible)
{
	impossible = false;
	for (unsigned int i = 0; i < m.rows; i++)
	{
		if (m.data[i * m.cols + i] == 0)
		{
			for (unsigned int j = i + 1; j < m.rows; j++)
			{
				if (m.data[i * m.cols + j] != 0)
				{
					m.xcgh_rows(i, j);
					v.xcgh_elems(i, j);
					break;
				}
			}
		}
		if (m.data[i * m.cols + i] == 0)
		{
			unsigned int j = i;
			for (; i < m.rows; i++)
			{
				if (v[i] != 0)
					impossible = true;
			}
			m.resize_rows(j);
			v.resize(j);
			return;
		}
		for (unsigned int j = i + 1; j < m.rows; j++)
		{
			t rapp = -m.data[j * m.cols + i] / m.data[i * m.cols + i];
			m.sum_rows(i, j, rapp);
			v.sum_elems(i, j, rapp);
		}
	}
}

template <typename t>
ostream& operator<<(ostream& out, const mat<t>& m)
{
	out << '[';
	for (unsigned int i = 0; i < m.rows; i++)
	{
		out << "\n";
		out << '\t' << m[i];
	}
	out << "\n]\n";
	return out;
}

template <typename t>
istream& operator>>(istream& in, mat<t>& m)
{
	while (in.peek() == ' ' || in.peek() == '\t' || in.peek() == '\n')
		in.ignore(1);
	if (in.peek() != '[')
	{
		in.fail();
		return in;
	}
	in.ignore(1);
	if (m.data == nullptr)
	{
		datalist<vet<t>> l;
		unsigned int len;
		while (true)
		{
			vet<t> v;
			if (l.n() != 0)
				v.resize(len);
			in >> v;
			if (l.n() == 0)
				len = v.size();
			if (v.size() != len)
			{
				in.fail();
				return in;
			}
			l.add(v);
			while (in.peek() == ' ' || in.peek() == '\t' || in.peek() == '\n')
				in.ignore(1);
			if (in.peek() == ']')
			{
				m.rows = l.n();
				m.cols = len;
				m.data = new t[m.rows * m.cols];
				for (unsigned int i = 0; i < m.rows; i++)
				{
					v = l.read();
					for (unsigned int j = 0; j < m.cols; j++)
					{
						m.data[i * m.cols + j] = v[j];
					}
				}
				in.ignore(1);
				return in;
			}
			else if (in.peek() != '[')
			{
				in.fail();
				return in;
			}
		}
	}
	for (unsigned int i = 0; i < m.rows; i++)
	{
		vet<t> v;
		in >> v;
		if (v.size() != m.cols)
		{
			in.fail();
			return in;
		}
		for (unsigned int j = 0; j < m.cols; j++)
		{
			m.data[i * m.cols + j] = v[j];
		}
	}
	while (in.peek() == ' ' || in.peek() == '\t' || in.peek() == '\n')
		in.ignore(1);
	if (in.peek() != ']')
		in.fail();
	else
		in.ignore(1);
	return in;
}

template <typename t>
mat<t> operator*(t k, const mat<t>& m)
{
	mat<t> res(m.rows, m.cols);
	for (unsigned int i = 0; i < m.cols * m.rows; i++)
	{
		res.data[i] = m.data[i] * k;
	}
	return res;
}

template <typename t>
mat<t> operator*(const mat<t>& m, t k)
{
	mat<t> res(m.rows, m.cols);
	for (unsigned int i = 0; i < m.cols * m.rows; i++)
	{
		res.data[i] = m.data[i] * k;
	}
	return res;
}

template <typename t>
mat<t> operator/(const mat<t>& m, t k)
{
	mat<t> res(m.rows, m.cols);
	for (unsigned int i = 0; i < m.cols * m.rows; i++)
	{
		res.data[i] = m.data[i] / k;
	}
	return res;
}

template <typename t>
mat<t> operator*(const mat<t>& m1, const mat<t>& m2)
{
	if (m1.cols != m2.rows)
	{
		cerr << "error: sizes are not valid" << endl;
		return mat<t>(0);
	}
	mat<t> res(m1.rows, m2.cols);
	for (unsigned int i = 0; i < m1.rows; i++)
	{
		vet<t> r = m1.row(i);
		for (unsigned int j = 0; j < m2.cols; j++)
		{
			res.data[i * res.cols + j] = r * m2.col(j);
		}
	}
	return res;
}

template <typename t>
vet<t> operator*(const vet<t>& v, const mat<t>& m)
{
	if (v.size() != m.rows)
	{
		cerr << "error: sizes are not valid" << endl;
		return vet<t>(0);
	}
	vet<t> res(m.cols);
	for (unsigned int i = 0; i < m.cols; i++)
	{
		res[i] = v * m.col(i);
	}
	return res;
}

template <typename t>
vet<t> operator*(const mat<t>& m, const vet<t>& v)
{
	if (m.cols != v.size())
	{
		cerr << "error: sizes are not valid" << endl;
		return vet<t>(0);
	}
	vet<t> res(m.rows);
	for (unsigned int i = 0; i < m.rows; i++)
	{
		res[i] = m.row(i) * v;
	}
	return res;
}

void riordina_basi(unsigned int* vett, unsigned int i, unsigned int l)
{
	while (i > 0 && vett[i] < vett[i - 1])
	{
		unsigned int a = vett[i];
		vett[i] = vett[i - 1];
		vett[i - 1] = a;
		i--;
	}
	while (i < l - 1 && vett[i] > vett[i + 1])
	{
		unsigned int a = vett[i];
		vett[i] = vett[i + 1];
		vett[i + 1] = a;
		i++;
	}
}

template <typename t>
vet<t> simplesso_primale(mat<t> A = mat<t>(0), vet<t> b = vet<t>(0), vet<t> c = vet<t>(0), unsigned int* B = nullptr)
{
	if (A.n_cols() == 0)
	{
		cout << "Inserisci la matrice A (vincoli per righe)" << endl;
		cin >> A;
	}
	if (b.size() == 0)
	{
		cout << "Inserisci il vettore b dei termini noti" << endl;
		cin >> b;
	}
	if (c.size() == 0)
	{
		cout << "Inserisci il vettore c della funzione obbiettivo" << endl;
		cin >> c;
	}
	unsigned int n = A.n_cols();
	unsigned int m = A.n_rows();
	if (n != c.size() || m != b.size())
	{
		cerr << "Dati non validi" << endl;
		return vet<t>(0);
	}
	bool new_b = false;
	if (B == nullptr)
	{
		B = new unsigned int[n];
		new_b = true;
		cout << "Inserisci gli indici della base: ";
		for (unsigned int i = 0; i < n; i++)
		{
			cin >> B[i];
			B[i]--;
		}
	}
	mat<t> AB(n);
	vet<t> bB(n);
	for (unsigned int i = 0; i < n; i++)
	{
		AB.row_reference(i) = A.row(B[i]);
		bB[i] = b[B[i]];
	}
	bool* idx = new bool[m];
	for (unsigned int i = 0; i < m; i++)
	{
		idx[i] = false;
	}
	for (unsigned int i = 0; i < n; i++)
	{
		idx[B[i]] = true;
	}
	unsigned int* N = new unsigned int[m - n];
	unsigned int j = 0;
	for (unsigned int i = 0; i < m; i++)
	{
		if (!idx[i])
			N[j++] = i;
	}
	delete[] idx;
	unsigned int passo = 0;
	cout << endl;
	cout << "Eseguo l'algoritmo del simplesso primale con questi dati:" << endl;
	cout << "A =" << endl << A;
	cout << "b = " << b << endl;
	cout << "c = " << c << endl;
	cout << "Base di partenza: B = {";
	for (unsigned int i = 0; i < n; i++)
	{
		cout << B[i] + 1;
		if (i != n - 1)
		{
			cout << "; ";
		}
	}
	cout << "}" << endl << endl;
	while (true)
	{
		{
			cout << "Passo " << passo + 1 << endl;
			cout << "Base: B = {";
			for (unsigned int i = 0; i < n; i++)
			{
				cout << B[i] + 1;
				if (i != n - 1)
				{
					cout << "; ";
				}
			}
			cout << "}" << endl;
		}
		mat<t> AB_1 = AB.inv();
		mat<t> W = -AB_1;
		cout << "AB = " << endl << AB;
		cout << "W = " << endl << W;
		cout << "bB = " << bB << endl;
		vet<t> yB = c * AB_1;
		vet<t> x = AB_1 * bB;
		cout << "x = " << x << endl;
		cout << "yB = " << yB << endl;
		unsigned int h;
		unsigned int k;
		t min = -1;
		for (unsigned int i = 0; i < n; i++)
		{
			if (yB[i] < 0)
			{
				h = i;
				break;
			}
			if (i == n - 1)
			{
				cout << "Siamo a una soluzione ottima" << endl;
				cout << "x = " << x << " \tmax = " << c * x << endl;
				delete[] N;
				if (new_b)
					delete[] B;
				return x;
			}
		}
		for (unsigned int i = 0; i < m - n; i++)
		{
			cout << "i = " << N[i] + 1 << " \t";
			t prod_i = A[N[i]] * W.col_reference(h);
			if (prod_i < 0.00000000001 && prod_i > -0.00000000001)
				prod_i = 0;
			cout << "AiWh = " << prod_i << " \t";
			if (prod_i <= 0)
			{
				cout << endl;
				continue;
			}
			t rapp_i = (b[N[i]] - A.row_reference(N[i]) * x) / prod_i;
			cout << "bi - Aix/AiWh = " << rapp_i << "\n";
			if (min < 0)
			{
				min = rapp_i;
				k = i;
			}
			else if (rapp_i < min)
			{
				min = rapp_i;
				k = i;
			}
		}
		if (min < 0)
		{
			cout << "Soluzione ottima infinita" << endl;
			delete[] N;
			if (new_b)
				delete[] B;
			return vet<t>(0);
		}
		cout << "h = " << B[h] + 1 << "\t k = " << N[k] + 1 << endl;
		unsigned int a = B[h];
		B[h] = N[k];
		N[k] = a;
		riordina_basi(B, h, n);
		riordina_basi(N, k, m - n);
		for (unsigned int i = 0; i < n; i++)
		{
			AB.row_reference(i) = A.row(B[i]);
			bB[i] = b[B[i]];
		}
		cout << endl;
		passo++;
	}
}

template <typename t>
vet<t> simplesso_duale(mat<t> A = mat<t>(0), vet<t> b = vet<t>(0), vet<t> c = vet<t>(0), unsigned int* B = nullptr)
{
	if (A.n_cols() == 0)
	{
		cout << "Inserisci la matrice A (vincoli per colonne)" << endl;
		cin >> A;
	}
	if (b.size() == 0)
	{
		cout << "Inserisci il vettore b della funzione obbiettivo" << endl;
		cin >> b;
	}
	if (c.size() == 0)
	{
		cout << "Inserisci il vettore c dei termini noti" << endl;
		cin >> c;
	}
	unsigned int n = A.n_cols();
	unsigned int m = A.n_rows();
	if (n != c.size() || m != b.size())
	{
		cerr << "Dati non validi" << endl;
		return vet<t>(0);
	}
	bool new_b = false;
	if (B == nullptr)
	{
		B = new unsigned int[n];
		new_b = true;
		cout << "Inserisci gli indici della base: ";
		for (unsigned int i = 0; i < n; i++)
		{
			cin >> B[i];
			B[i]--;
		}
	}
	mat<t> AB(n);
	vet<t> bB(n);
	for (unsigned int i = 0; i < n; i++)
	{
		AB.row_reference(i) = A.row(B[i]);
		bB[i] = b[B[i]];
	}
	bool* idx = new bool[m];
	for (unsigned int i = 0; i < m; i++)
	{
		idx[i] = false;
	}
	for (unsigned int i = 0; i < n; i++)
	{
		idx[B[i]] = true;
	}
	unsigned int* N = new unsigned int[m - n];
	unsigned int j = 0;
	for (unsigned int i = 0; i < m; i++)
	{
		if (!idx[i])
			N[j++] = i;
	}
	delete[] idx;
	unsigned int passo = 0;
	cout << endl;
	cout << "Eseguo l'algoritmo del simplesso duale con questi dati:" << endl;
	cout << "A =" << endl << A;
	cout << "b = " << b << endl;
	cout << "c = " << c << endl;
	cout << "Base di partenza: B = {";
	for (unsigned int i = 0; i < n; i++)
	{
		cout << B[i] + 1;
		if (i != n - 1)
		{
			cout << "; ";
		}
	}
	cout << "}" << endl << endl;
	while (true)
	{
		{
			cout << "Passo " << passo + 1 << endl;
			cout << "Base: B = {";
			for (unsigned int i = 0; i < n; i++)
			{
				cout << B[i] + 1;
				if (i != n - 1)
				{
					cout << "; ";
				}
			}
			cout << "}" << endl;
		}
		mat<t> AB_1 = AB.inv();
		mat<t> W = -AB_1;
		cout << "AB = " << endl << AB;
		cout << "W = " << endl << W;
		cout << "bB = " << bB << endl;
		vet<t> yB = c * AB_1;
		vet<t> x = AB_1 * bB;
		cout << "x = " << x << endl;
		cout << "yB = " << yB << endl;
		unsigned int h;
		unsigned int k;
		t min = -1;
		for (unsigned int i = 0; i < m - n; i++)
		{
			if (A.row_reference(N[i]) * x > b[N[i]])
			{
				k = i;
				break;
			}
			if (i == m - n - 1)
			{
				cout << "Siamo a una soluzione ottima" << endl;
				j = 0;
				vet<t> y(m);
				for (unsigned int ii = 0; ii < m; ii++)
				{
					if (B[j] == ii)
						y[ii] = yB[j++];
					else
						y[ii] = 0;
				}
				cout << "y = " << y << " \tmin = " << bB * yB << endl;
				delete[] N;
				if (new_b)
					delete[] B;
				return y;
			}
		}
		for (unsigned int i = 0; i < n; i++)
		{
			cout << "i = " << B[i] + 1 << " \t";
			t prod_i = A[N[k]] * W.col_reference(i);
			if (prod_i < 0.00000000001 && prod_i > -0.00000000001)
				prod_i = 0;
			cout << "AkWi = " << prod_i << " \t";
			if (prod_i >= 0)
			{
				cout << endl;
				continue;
			}
			t rapp_i = -yB[i] / prod_i;
			cout << "-yi/AkWi = " << rapp_i << "\n";
			if (min < 0)
			{
				min = rapp_i;
				h = i;
			}
			else if (rapp_i < min)
			{
				min = rapp_i;
				h = i;
			}
		}
		if (min < 0)
		{
			cout << "Soluzione ottima infinita" << endl;
			delete[] N;
			if (new_b)
				delete[] B;
			return vet<t>(0);
		}
		cout << "h = " << B[h] + 1 << "\t k = " << N[k] + 1 << endl;
		unsigned int a = B[h];
		B[h] = N[k];
		N[k] = a;
		riordina_basi(B, h, n);
		riordina_basi(N, k, m - n);
		for (unsigned int i = 0; i < n; i++)
		{
			AB.row_reference(i) = A.row(B[i]);
			bB[i] = b[B[i]];
		}
		cout << endl;
		passo++;
	}
}

template <typename t>
vet<t>  risolvi_PL_duale_standard(mat<t> A, vet<t> b, vet<t> c)
{
	unsigned int n = A.n_cols();
	unsigned int m = A.n_rows();
	if (m != b.size() || n != c.size())
	{
		cerr << "Dati non validi!" << endl;
		return mat<t>(0);
	}
	bool imp;
	if (A.rank() != m < n ? m : n)
	{
		cout << endl << "Il problema contiene equazioni ridondanti, prima di iniziare e' necessario semplificarle" << endl;
		simplify_col_system(A, c, imp);
		n = A.n_cols();
		m = A.n_rows();
	}
	if(imp)
		cout << "Il problema non ha soluzione!" << endl;
	mat<t> Aaux(m + n, n);
	vet<t> baux(m + n);
	unsigned int* B = new unsigned int[n];
	for (unsigned int i = 0; i < m; i++)
	{
		Aaux.row_reference(i) = A.row(i);
		baux[i] = 0;
	}
	for (unsigned int i = m; i < m + n; i++)
	{
		for (unsigned int j = 0; j < n; j++)
		{
			if (i - m == j)
			{
				if (c[i - m] >= 0)
				{
					Aaux[i][j] = 1;
				}
				else
				{
					Aaux[i][j] = -1;
				}
			}
			else
			{
				Aaux[i][j] = 0;
			}
		}
		baux[i] = 1;
		B[i - m] = i;
	}

	cout << endl << "Come prima cosa eseguiamo il duale ausiliario per trovare una base ammissibile di partenza" << endl;

	vet<t> aux_sol = simplesso_duale(Aaux, baux, c, B);
	if (aux_sol * baux != 0)
	{
		cout << endl << "Il problema non ha soluzione!" << endl;
		delete[] B;
		return vet<t>(0);
	}
	cout << endl << "Trovata la base ammissibile di partenza, ora possiamo utilizzare l'algoritmo del simplesso" << endl;
	unsigned int j = 0;
	unsigned int k = 0;
	for (unsigned int i = 0; i < n; i++)
	{
		if (B[i] >= m)
		{
			while (true)
			{
				if (B[k] == j)
				{
					j++;
					k++;
					continue;
				}
				if (aux_sol[j] == 0)
				{
					B[i] = j;
					break;
				}
				j++;
			}
		}
	}
	Quicksort(B, n);
	vet<t> sol = simplesso_duale(A, b, c, B);
	delete[] B;
	return sol;
}

template <typename t>
vet<t> problema_PL_duale()
{
	mat<t> A;
	vet<t> b;
	vet<t> c;
	cout << "Inserisci la matrice A (vincoli per righe)" << endl;
	cin >> A;
	cout << "Inserisci il vettore dei termini noti" << endl;
	cin >> c;
	cout << "Inserisci la funzione obbiettivo" << endl;
	cin >> b;
	return risolvi_PL_duale_standard(A.transp(), b, c);
}

bool next_base(unsigned int*& B, unsigned int l, unsigned int n)
{
	if (B == nullptr)
	{
		B = new unsigned int[l];
		for (unsigned int i = 0; i < l; i++)
		{
			B[i] = i;
		}
		return true;
	}
	else
	{
		unsigned int i = 1;
		while (B[l - i] == n - i)
			i++;
		B[l - i]++;
		i--;
		while (l - i < l)
		{
			B[l - i] = B[l - i - 1] + 1;
			if (B[l - i] >= n)
				return false;
			i--;
		}
	}
	return true;
}

template <typename t>
vet<t>  risolvi_PL_primale_standard(mat<t> A, vet<t> b, vet<t> c)
{
	unsigned int n = A.n_cols();
	unsigned int m = A.n_rows();
	if (m != b.size() || n != c.size())
	{
		cerr << "Dati non validi!" << endl;
		return mat<t>(0);
	}
	/*
	bool imp;
	if (A.rank() != m < n ? m : n)
	{
		cout << endl << "Il problema contiene equazioni ridondanti, prima di iniziare e' necessario semplificarle" << endl;
		simplify_row_system(A, b, imp);
		m = A.n_cols();
		n = A.n_rows();
	}
	if (imp)
		cout << endl << "Il problema non ha soluzione!" << endl;
	*/
	unsigned int* B = nullptr;
	mat<t> AB(n);
	vet<t> bB(n);
	do
	{
		next_base(B, n, m);
		for (unsigned int i = 0; i < n; i++)
		{
			AB.row_reference(i) = A.row(B[i]);
			bB[i] = b[B[i]];
		}
	} while (AB.det() == 0);
	vet<t> x = AB.inv() * bB;

	unsigned int j = 0;
	for (unsigned int i = 0; i < m; i++)
	{
		if (A.row_reference(i) * x > b[i])
			j++;
	}
	if (j == 0)
	{
		cout << endl << "La prima base selezionata e' gia' ammissibile quindi procedo eseguendo il simplesso primale" << endl;
		return simplesso_primale(A, b, c, B);
	}
	unsigned int* V = new unsigned int[j];
	unsigned int k = 0, h = 0;
	j = 0;

	for (unsigned int i = 0; i < m; i++)
	{
		if (B[j] == i)
			j++;
		else if (A.row_reference(i) * x > b[i])
			V[k++] = i;
	}
	j = k;
	mat<t> Aaux(m + j, n + j);
	vet<t> baux(m + j);
	vet<t> caux(n + j);
	k = 0;
	for (unsigned int i = 0; i < m + j; i++)
	{
		for (unsigned int ii = 0; ii < n + j; ii++)
		{
			if (i < m && ii < n)
			{
				Aaux[i][ii] = A[i][ii];
			}
			else if (i >= m)
			{
				if (ii < n)
					Aaux[i][ii] = 0;
				else
				{
					if (i - m == ii - n)
						Aaux[i][ii] = -1;
					else
						Aaux[i][ii] = 0;
				}
			}
			else
			{
				if (i == V[k])
				{
					for (int iii = n; iii < n + j; iii++)
					{
						if (iii - n == k)
							Aaux[i][iii] = -1;
						else
							Aaux[i][iii] = 0;
					}
					k++;
				}
				else
				{
					for (int iii = n; iii < n + j; iii++)
					{
						Aaux[i][iii] = 0;
					}
				}
				break;
			}
		}
	}
	for (unsigned int i = 0; i < m + j; i++)
	{
		if (i < m)
			baux[i] = b[i];
		else
			baux[i] = 0;
	}
	unsigned int* Baux = new unsigned int[n + j];
	for (unsigned int i = 0; i < n + j; i++)
	{
		if (i < n)
		{
			caux[i] = 0;
			Baux[i] = B[i];
		}
		else
		{
			caux[i] = -1;
			Baux[i] = V[i - n];
		}
	}
	j = 0;
	k = 0;
	for (unsigned int i = 0; i < n; i++)
	{
		if (Baux[i] >= m)
		{
			while (true)
			{
				if (Baux[k] == j)
				{
					j++;
					k++;
					continue;
				}
				if (A.row_reference(i) * x == b[i])
				{
					Baux[i] = j;
					break;
				}
				j++;
			}
		}
	}
	Quicksort(Baux, n);
	delete[] B;
	cout << endl << "Come prima cosa eseguiamo il primale ausiliario per trovare una base ammissibile di partenza" << endl;

	vet<t> aux_sol = simplesso_primale(Aaux, baux, caux, Baux);
	if (aux_sol * caux != 0)
	{
		cout << endl << "Il problema non ha soluzione!" << endl;
		delete[] Baux;
		delete[] V;
		return vet<t>(0);
	}
	else
	{
		cout << endl << "Trovata la base ammissibile di partenza, ora possiamo utilizzare l'algoritmo del simplesso" << endl;
		vet<t> res = simplesso_primale(A, b, c, Baux);
		delete[] Baux;
		delete[] V;
		return res;
	}
}

template <typename t>
vet<t> problema_PL_primale()
{
	mat<t> A;
	vet<t> b;
	vet<t> c;
	cout << "Inserisci la matrice A (vincoli per righe)" << endl;
	cin >> A;
	cout << "Inserisci il vettore dei termini noti" << endl;
	cin >> b;
	cout << "Inserisci la funzione obbiettivo" << endl;
	cin >> c;
	return risolvi_PL_primale_standard(A, b, c);
}

template <typename t>
vet<t> calcola_gradiente_quadratiche(vet<t> x = vet<t>(0), vet<t> v = vet<t>(0))
{
	while (v.size() != 6)
	{
		cout << "Inserisci i coefficienti della funzione in un vettore in questo ordine" << endl;
		cout << "a*x^2 + b*y^2 + c*xy + d*x + e*y + f" << endl;
		cin >> v;
	}
	while (x.size() != 2)
	{
		cout << "Inserisci il punto in un vettore [x, y] in cui calcolare il gradiente" << endl;
		cin >> x;
	}
	cout << "f'([x, y]) = [";
	if (v[0] != 0)
	{
		if (2 * v[0] == 1)
			cout << "x";
		else
			cout << 2 * v[0] << "x";
	}
	if (v[2] > 0 && v[0] != 0)
		cout << '+';
	if (v[2] != 0)
	{
		if (v[2] == 1)
			cout << "y";
		else
			cout << v[2] << "y";
	}
	if (v[3] > 0 && (v[2] != 0 || v[2] == 0 && v[0] != 0))
		cout << '+';
	if (v[3] != 0)
		cout << v[3] << ", ";
	else if (v[0] == 0 && v[2] == 0 && v[3] == 0)
		cout << "0, ";
	else cout << ", ";

	if (v[2] != 0)
	{
		if (v[2] == 1)
			cout << "x";
		else
			cout << v[2] << "x";
	}
	if (v[1] > 0 && v[2] != 0)
		cout << '+';
	if (v[1] != 0)
	{
		if (2 * v[1] == 1)
			cout << "y";
		else
			cout << 2 * v[1] << "y";
	}
	if (v[4] > 0 && (v[1] != 0 || v[1] == 0 && v[2] != 0))
		cout << '+';
	if (v[4] != 0)
		cout << v[4] << "]" << endl;
	else if (v[1] == 0 && v[2] == 0 && v[4] == 0)
		cout << "0]" << endl;
	else cout << ']' << endl;
	vet<t> res(2);
	res[0] = 2 * v[0] * x[0] + v[2] * x[1] + v[3];
	res[1] = 2 * v[1] * x[1] + v[2] * x[0] + v[4];
	cout << "f'(" << x << ") = " << res << endl;
	cout << "f(" << x << ") = " << v[0] * x[0] * x[0] + v[1] * x[1] * x[1] + v[2] * x[0] * x[1] + v[3] * x[0] + v[4] * x[1] + v[5] << endl;
	return res;
}

template <typename t>
void passo_gradiente_proiettato(mat<t> A = mat<t>(0), vet<t> b = vet<t>(0), vet<t> c = vet<t>(0), vet<t> x = vet<t>(0))
{
	if (A.n_cols() == 0)
	{
		cout << "Inserisci la matrice A (vincoli per righe)" << endl;
		cin >> A;
	}
	if (b.size() == 0)
	{
		cout << "Inserisci il vettore b dei termini noti" << endl;
		cin >> b;
	}
	if (x.size() == 0)
	{
		cout << "Inserisci il vettore x punto di partenza" << endl;
		cin >> x;
	}
	if (c.size() == 0)
	{
		cout << "Inserisci il vettore c, gradiente della funzione obbiettivo in x, o un vettore vuoto per calcolare automaticamente il gradiente in caso di funzione quadratica" << endl;
		cin >> c;
		if (c.size() == 0)
			c = calcola_gradiente_quadratiche(x);
	}
	cout << endl;
	unsigned int n = A.n_cols();
	unsigned int m = A.n_rows();
	if (m != b.size() || n != c.size())
	{
		cerr << "Dati non validi!" << endl;
		return;
	}
	if (A*x > b)
	{
		cerr << "Errore: il punto iniziale non e' ammissibile" << endl;
		return;
	}
	unsigned int v_a = 0;
	for (unsigned int i = 0; i < A.n_rows(); i++)
	{
		if (A.row_reference(i) * x == b[i])
			v_a++;
	}
	mat<t> V(v_a, A.n_cols());
	v_a = 0;
	for (unsigned int i = 0; i < A.n_rows(); i++)
	{
		if (A.row_reference(i) * x == b[i])
			V.row_reference(v_a++) = A.row(i);
	}
	cout << "V =" << endl << V;
	vet<t> dk;
	while(true)
	{
		mat<t> H = mat<t>('I', (int)n) - V.transp() * (V * V.transp()).inv() * V;
		cout << "H = I - Vt * (V * Vt)^-1 * V =" << endl << H;
		dk = H * c;
		cout << "dk = H * f'(x) = " << dk << endl;
		if (dk != vet<t>('0', (int)dk.size()))
			break;
		vet<t>u = - (V*V.transp()).inv() * V * c;
		cout << "Lambda = -(V * Vt)^-1 * V * f'(x) = " << u << endl;
		if (u <= vet<t>('0', (int)u.size()))
		{
			cout << "Lambda <= 0: fine algoritmo, siamo a un potenziale massimo per LKKT" << endl;
			return;
		}
		else
		{
			t max = numeric_limits<t>::min();
			unsigned int ind = -1;
			for (unsigned int i = 0; i < u.size(); i++)
			{
				if (u[i] > max)
				{
					max = u[i];
					ind = i;
				}
			}
			V.delete_row(ind);
		}
	}
	mat<t> _A = A * dk;
	vet<t> _b = b - A * x;
	vet<t> _c(1);
	_c[0] = 1;
	cout << endl << "Per trovare il massimo di t risolvo un problema primale con questi dati:" << endl;
	cout << "A =" << endl << _A;
	cout << "b = " << _b << endl;
	cout << "c = " << _c << endl;
	vet<t> res = risolvi_PL_primale_standard(_A, _b, _c);
	t max_t = res[0];
	cout << "Il massimo t per non uscire dal poliedro e' quindi ";
	cout << max_t << endl;
}

template <typename t>
void passo_di_frank_wolfe(mat<t> A = mat<t>(0), vet<t> b = vet<t>(0), vet<t> c = vet<t>(0), vet<t> x = vet<t>(0))
{
	if (A.n_cols() == 0)
	{
		cout << "Inserisci la matrice A (vincoli per righe)" << endl;
		cin >> A;
	}
	if (b.size() == 0)
	{
		cout << "Inserisci il vettore b dei termini noti" << endl;
		cin >> b;
	}
	if (x.size() == 0)
	{
		cout << "Inserisci il vettore x punto di partenza" << endl;
		cin >> x;
	}
	if (c.size() == 0)
	{
		cout << "Inserisci il vettore c, gradiente della funzione obbiettivo in x, o un vettore vuoto per calcolare automaticamente il gradiente in caso di funzione quadratica" << endl;
		cin >> c;
		if (c.size() == 0)
			c = calcola_gradiente_quadratiche(x);
	}
	vet<t> dk = risolvi_PL_primale_standard(A, b, c) - x;
	cout << endl << "dk = " << dk << endl;
}

template<typename t>
t fraz(t x)
{
	return x - (t)(floor(x));
}

template<typename t>
void aggiungi_positivita(mat<t>& A, vet<t>& b)
{
	unsigned int n = A.n_cols();
	unsigned int m = A.n_rows();
	A.resize_rows(m + n);
	b.resize(m + n);
	for (unsigned int i = 0; i < n; i++)
	{
		for (unsigned int ii = 0; ii < n; ii++)
		{
			if (i == ii)
				A[m + i][ii] = -1;
			else
				A[m + i][ii] = 0;
		}
		b[m + i] = 0;
	}
}

template<typename t>
void rimuovi_positivita(mat<t>& A, vet<t>& b)
{
	unsigned int n = A.n_cols();
	unsigned int m = A.n_rows();
	for (unsigned int i = 0; i < m; i++)
	{
		bool menouno = false;
		for (unsigned int ii = 0; ii < n; ii++)
		{
			if (A[i][ii] == 0)
				continue;
			if (!menouno && A[i][ii] == -1)
			{
				menouno = true;
				continue;
			}
			menouno = false;
			break;
		}
		if (menouno && b[i] == 0)
		{
			A.delete_row(i);
			b.delete_elem(i);
			i--;
			m--;
		}
	}
}

template <typename t>
vet<t> taglio_di_gomory(mat<t> A = mat<t>(0), vet<t> b = vet<t>(0), vet<t> x = vet<t>(0), vet<t> c = vet<t>(0), bool sempre_primo_taglio = false)
{
	if (A.n_cols() == 0)
	{
		cout << "Inserire il poliedro in formato primale, escludendo i vincoli di positivita' delle variabili (impliciti)" << endl;
		cout << "Inserisci la matrice A (vincoli per righe)" << endl;
		cin >> A;
	}
	if (b.size() == 0)
	{
		cout << "Inserisci il vettore b dei termini noti" << endl;
		cin >> b;
	}
	if (x.size() == 0)
	{
		cout << "Inserisci il vettore x punto di partenza" << endl;
		cin >> x;
	}
	rimuovi_positivita(A, b);
	unsigned int n = A.n_cols();
	unsigned int m = A.n_rows();
	if (m != b.size())
	{
		cerr << "Dati non validi" << endl;
		return vet<t>(0);
	}
	mat<t> A2 = A;
	vet<t> x2 = x;
	A2.resize_cols(m + n);
	x2.resize(m + n);
	for (unsigned int i = 0; i < m; i++)
	{
		for (unsigned int ii = n; ii < n + m; ii++)
		{
			if (i + n == ii)
				A2[i][ii] = 1;
			else
				A2[i][ii] = 0;
		}
		x2[n + i] = b[i] - A.row_reference(i) * x;
	}
	datalist<t> d;
	for (int i = 0; i < m + n; i++)
	{
		if (x2[i] != floor(x2[i]))
			d.add(i);
	}
	if (d.n() == 0)
	{
		cout << "La soluzione ottima e' gia' intera!" << endl;
		return vet<t>(0);
	}
	unsigned int* B = new unsigned int[m];
	unsigned int* N = new unsigned int[n];
	cout << "Trasformo il poliedro in formato duale" << endl <<  "A = " << endl << A2;
	cout << "x = " << x2 << endl;
	mat<t> AB(m, m);
	mat<t> AN(m, n);
	unsigned int n_b = 0, n_n = 0;
	for (unsigned int i = 0; i < n + m; i++)
	{
		if (x2[i] != 0 || n_n == n)
		{
			AB.col_reference(n_b) = A2.col(i);
			B[n_b++] = i;
		}
		else
		{
			AN.col_reference(n_n) = A2.col(i);
			N[n_n++] = i;
		}
	}
	cout << "AB = " << endl << AB;
	cout << "AN = " << endl << AN;
	cout << "AB^-1 = " << endl << AB.inv();
	mat<t> At = AB.inv() * AN;
	cout << "Atilde = " << endl << At;
	unsigned int o = 0 - 1;
	if (d.n() == 1 || sempre_primo_taglio)
		o = 0;
	while (o > d.n())
	{
		cout << "Inserisci il numero del taglio che vuoi eseguire (0 - " << d.n() - 1 << ")" << endl;
		cin >> o;
	}
	while (o-- != 0)
		d.read();
	o = d.read();
	vet<t> taglio(n_n);
	t termine_noto_taglio;
	for (unsigned int i = 0; i < n_n; i++)
	{
		taglio[i] = fraz(At[o][i]);
	}
	termine_noto_taglio = fraz(x2[B[o]]);
	cout << "Taglio di gomory:" << endl;
	for (int i = 0; i < n_n; i++)
	{
		cout << taglio[i] << "*x" << N[i] + 1;
		if (i + 1 < n_n && taglio[i + 1] >= 0)
			cout << '+';
	}
	cout << " >= " << termine_noto_taglio << endl;
	vet<t> taglio_base('0', (int)n);
	t termine_noto_taglio_base = -termine_noto_taglio;
	for (unsigned int i = 0; i < n_n; i++)
	{
		if (N[i] >= n)
		{
			taglio_base += taglio[i] * A.row_reference(N[i] - n);
			termine_noto_taglio_base += taglio[i] * b[N[i] - n];
		}
		else
			taglio_base[N[i]] -= taglio[i];
	}
	cout << "Taglio di gomory con le variabili originali:" << endl;
	for (int i = 0; i < n; i++)
	{
		cout << taglio_base[i] << "*x" << i + 1;
		if (i + 1 < n && taglio_base[i + 1] >= 0)
			cout << '+';
	}
	cout << " <= " << termine_noto_taglio_base << endl;
	aggiungi_positivita(A, b);
	A.resize_rows(m + n + 1);
	b.resize(m + n + 1);
	A.row_reference(m + n) = taglio_base;
	b[m + n] = termine_noto_taglio_base;
	if (c.size() == 0)
	{
		cout << "Inserisci il vettore c della funzione obbiettivo" << endl;
		cin >> c;
	}
	risolvi_PL_primale_standard(A, b, c);
 	delete[] B;
	delete[] N;
	taglio_base.resize(n + 1);
	taglio_base[n] = termine_noto_taglio_base;
	return taglio_base;
}

template<typename t>
bool intero(vet<t> v)
{
	for (unsigned int i = 0; i < v.size(); i++)
	{
		if (v[i] != floor(v[i]))
			return false;
	}
	return true;
}

template<typename t>
void tagli_di_gomory(mat<t> A = mat<t>(0), vet<t> b = vet<t>(0), vet<t> c = vet<t>(0))
{
	cout << "Inserisci la matrice A (vincoli per righe), sottointesi i vincoli di positivita'" << endl;
	cin >> A;
	cout << "Inserisci il vettore dei termini noti" << endl;
	cin >> b;
	cout << "Inserisci la funzione obbiettivo" << endl;
	cin >> c;
	vet<t> x;
	vet<t> Gomory;
	rimuovi_positivita(A, b);
	aggiungi_positivita(A, b);
	x = risolvi_PL_primale_standard(A, b, c);
	unsigned int h = 1;
	while (!intero(x))
	{
		cout << endl << "TAGLIO DI GOMORY NUMERO " << h++ << endl << endl;
		Gomory = taglio_di_gomory(A, b, x, c, true);
		A.resize_rows(A.n_rows() + 1);
		for (unsigned int i = 0; i < Gomory.size() - 1; i++)
		{
			A[A.n_rows() - 1][i] = Gomory[i];
		}
		b.resize(b.size() + 1);
		b[b.size() - 1] = Gomory[Gomory.size() - 1];
		x = risolvi_PL_primale_standard(A, b, c);
	}
}

template<typename t>
void simplesso_gomory(mat<t> A = mat<t>(0), vet<t> b = vet<t>(0), vet<t> c = vet<t>(0))
{
	cout << "Inserisci la matrice A (vincoli per righe), sottointesi i vincoli di positivita'" << endl;
	cin >> A;
	cout << "Inserisci il vettore dei termini noti" << endl;
	cin >> b;
	cout << "Inserisci la funzione obbiettivo" << endl;
	cin >> c;
	vet<t> x;
	rimuovi_positivita(A, b);
	aggiungi_positivita(A, b);
	int h;
	cout << "Scrivi 0 se hai gia' una base di partenza" << endl;
	cin >> h;
	if (h == 0)
		x = simplesso_primale(A, b, c);
	else
		x = risolvi_PL_primale_standard(A, b, c);
	if (!intero(x))
	{
		cout << endl << "Ora calcolo il taglio di Gomory" << endl << endl;
		taglio_di_gomory(A, b, x, c);
	}
	else
	{
		cout << endl << "La soluzione e' gia' intera!" << endl << endl;
	}
}

#include <iostream>
#include <limits>
using namespace std;

template<class L>
struct percorso
{
	L label;
	percorso* next;
	percorso(L l, percorso* n = nullptr)
	{
		label = l;
		next = n;
	}
};

template<class L, class P>
struct strada
{
	percorso<L>* p;
	P lunghezza;
	strada()
	{
		p = nullptr;
		lunghezza = numeric_limits<P>::max();
	}
	void stampa()
	{
		if (lunghezza == 0 && p == nullptr)
		{
			cout << " --" << endl;
			return;
		}
		else if (p == nullptr)
		{
			cout << " Nessuna strada" << endl;
			return;
		}
		percorso<L>* p2 = p;
		while (p2 != nullptr)
		{
			cout << " -> " << p2->label;
			p2 = p2->next;
		}
		cout << " (" << lunghezza << ")" << endl;
	}
	~strada()
	{
		while (p != nullptr)
		{
			percorso<L>* p2 = p->next;
			delete[] p;
			p = p2;
		}
	}
};

template<class P>
struct dist
{
	P distanza;
	int from_id;
};

template<class P>
struct DijkstraHeap
{
	dist<P>* Distanze;
	int* heap;
	int n_attivi;
	static int dad(int n)
	{
		return (n - 1) / 2;
	}
	static int lson(int n)
	{
		return n * 2 + 1;
	}
	static int rson(int n)
	{
		return n * 2 + 2;
	}
	DijkstraHeap(int n)
	{
		n_attivi = n;
		Distanze = new dist<P>[n];
		heap = new int[n];
		for (int i = 0; i < n; i++)
		{
			Distanze[i].distanza = numeric_limits<P>::max();
			Distanze[i].from_id = -2;
			heap[i] = i;
		}
	}
	static void swap(int& c1, int& c2)
	{
		int c = c1;
		c1 = c2;
		c2 = c;
	}
	void up(int id)
	{
		if (id == 0)
			return;
		if (Distanze[heap[id]].distanza < Distanze[heap[dad(id)]].distanza)
		{
			swap(heap[id], heap[dad(id)]);
			up(dad(id));
		}
	}
	void down(int id = 0)
	{
		int l = lson(id), r = rson(id);
		if (l >= n_attivi || r >= n_attivi && Distanze[heap[id]].distanza < Distanze[heap[l]].distanza || Distanze[heap[id]].distanza < Distanze[heap[l]].distanza && Distanze[heap[id]].distanza < Distanze[heap[r]].distanza)
			return;
		if (r >= n_attivi || Distanze[heap[l]].distanza < Distanze[heap[r]].distanza)
		{
			swap(heap[l], heap[id]);
			down(l);
			return;
		}
		swap(heap[r], heap[id]);
		down(r);
	}
	int Extract()
	{
		int i = heap[0];
		swap(heap[0], heap[n_attivi - 1]);
		n_attivi--;
		down();
		return i;
	}
	~DijkstraHeap()
	{
		delete[] heap;
		delete[] Distanze;
	}
};

template<class P>
struct Connection
{
	int id1;
	int id2;
	P peso;
};

template<class P>
class Connection_heap
{
	Connection<P>* vett;
	int tot_n_conn;
	int n_conn;
	static int dad(int n)
	{
		return (n - 1) / 2;
	}
	static int lson(int n)
	{
		return n * 2 + 1;
	}
	static int rson(int n)
	{
		return n * 2 + 2;
	}
	static void swap(Connection<P>& c1, Connection<P>& c2)
	{
		Connection<P> c = c1;
		c1 = c2;
		c2 = c;
	}
	void down(int id = 0)
	{
		int l = lson(id), r = rson(id);
		if (l >= n_conn || r >= n_conn && vett[id].peso < vett[l].peso || vett[id].peso < vett[l].peso && vett[id].peso < vett[r].peso)
			return;
		if (r >= n_conn || vett[l].peso < vett[r].peso)
		{
			swap(vett[l], vett[id]);
			down(l);
			return;
		}
		swap(vett[r], vett[id]);
		down(r);
	}
public:
	Connection_heap(int n)
	{
		tot_n_conn = n;
		n_conn = 0;
		vett = new Connection<P>[n];
	}
	void add_Connection(int _id1, int _id2, P _peso)
	{
		if (n_conn == tot_n_conn)
			return;
		vett[n_conn].id1 = _id1;
		vett[n_conn].id2 = _id2;
		vett[n_conn].peso = _peso;
		n_conn++;
	}
	void Heapify()
	{
		int last_dad = dad(n_conn - 1);
		for (int i = last_dad; i >= 0; i--)
		{
			down(i);
		}
	}
	Connection<P> Extract()
	{
		Connection<P> c = vett[0];
		n_conn--;
		vett[0] = vett[n_conn];
		down();
		return c;
	}
	~Connection_heap()
	{
		delete[] vett;
	}
};

template<class L, class P, bool orientato>
class Grafo
{
protected:
	int n;
	L* labels;
	bool* mark;
	virtual int get_n_connections() = 0;
	virtual void get_connections(Connection_heap<P>& ch) = 0;
	int get_id_from_label(L l)
	{
		for (int i = 0; i < n; i++)
		{
			if (labels[i] == l)
				return i;
		}
		return -1;
	}
	Grafo(int l, const L* _labels)
	{
		n = l;
		labels = new L[n];
		mark = new bool[n];
		for (int i = 0; i < n; i++)
		{
			labels[i] = _labels[i];
		}
	}
	virtual void visita_nodo(int id) = 0;
	virtual bool add_connection(int id, int to_id, P peso) = 0;
	virtual bool mark_connections(int form_id, int to_id) = 0;
	virtual ~Grafo()
	{
		delete[] labels;
		delete[] mark;
	};
	bool connessi_id(int from_id, int to_id)
	{
		for (int i = 0; i < n; i++)
		{
			mark[i] = false;
		}
		return mark_connections(from_id, to_id);
	}
public:
	int get_n()
	{
		return n;
	}
	L get_label(int id)
	{
		if (id >= 0 && id < n)
			return labels[id];
		else
			return '\0';
	}
	void Depth_Visit()
	{
		for (int i = 0; i < n; i++)
		{
			mark[i] = false;
		}
		for (int i = 0; i < n; i++)
		{
			if (!mark[i])
				visita_nodo(i);
		}
	}
	bool connessi(L from, L to)
	{
		int from_id = get_id_from_label(from);
		int to_id = get_id_from_label(to);
		if (from_id < 0 || to_id < 0)
			return false;
		return connessi_id(from_id, to_id);
	}
	bool aggiungi_connessione(L from, L to, P peso)
	{
		int id1 = get_id_from_label(from);
		int id2 = get_id_from_label(to);
		if (id1 < 0 || id2 < 0)
			return false;
		if (orientato)
			return add_connection(id1, id2, peso);
		else
		{
			add_connection(id1, id2, peso);
			return add_connection(id2, id1, peso);
		}
	}
	virtual void add_node(L label) = 0;
	virtual void stampa() = 0;
	virtual Grafo<L, P, false>* Kruskal() = 0;
	virtual strada<L, P>* Dijkstra(L start) = 0;
};

template<class L, class P, bool orientato>
class Grafo_liste : public Grafo<L, P, orientato>
{
	struct adiacenza
	{
		int id;
		P peso;
		adiacenza* next;
		adiacenza(int _id, P _peso, adiacenza* _next = nullptr)
		{
			id = _id;
			peso = _peso;
			next = _next;
		}
	};
	adiacenza** liste;
	bool add_connection(int id, int to_id, P peso)
	{
		adiacenza*& lista = liste[id];
		if (lista == nullptr)
			lista = new adiacenza(to_id, peso);
		adiacenza* l2 = lista;
		while (l2->next != nullptr)
		{
			if (l2->id == to_id)
				return false;
			l2 = l2->next;
		}
		if (l2->id == to_id)
			return false;
		l2->next = new adiacenza(to_id, peso);
		return true;
	}
	int get_n_connections()
	{
		int nc = 0;
		for (int i = 0; i < this->n; i++)
		{
			adiacenza* a = liste[i];
			while (a != nullptr)
			{
				if (a->id <= i || orientato)
					nc++;
				a = a->next;
			}
		}
		return nc;
	}
	void get_connections(Connection_heap<P>& ch)
	{
		for (int i = 0; i < this->n; i++)
		{
			adiacenza* a = liste[i];
			while (a != nullptr)
			{
				if (a->id <= i || orientato)
				{
					ch.add_Connection(i, a->id, a->peso);
				}
				a = a->next;
			}
		}
		ch.Heapify();
	}
	void visita_nodo(int id)
	{
		this->mark[id] = true;
		cout << this->labels[id] << endl;
		adiacenza* a = liste[id];
		while (a != nullptr)
		{
			if (!this->mark[a->id])
				visita_nodo(a->id);
			a = a->next;
		}
	}
	bool mark_connections(int from_id, int to_id)
	{
		this->mark[from_id] = true;
		adiacenza* a = liste[from_id];
		while (a != nullptr)
		{
			if (a->id == to_id)
				return true;
			if (!this->mark[a->id])
				if (mark_connections(a->id, to_id))
					return true;
			a = a->next;
		}
		return false;
	}
public:
	Grafo_liste(int l, const L* _labels) : Grafo<L, P, orientato>(l, _labels)
	{
		liste = new adiacenza*[this->n];
		for (int i = 0; i < this->n; i++)
		{
			liste[i] = nullptr;
		}
	}
	Grafo_liste<L, P, false>* Kruskal()
	{
		if (orientato)
		{
			return nullptr;
			cout << "Kruskal funziona solo coi grafi non orientati";
		}
		int nc = get_n_connections();
		Connection_heap<P> C(nc);
		get_connections(C);
		Grafo_liste<L, P, false>* min_cop = new Grafo_liste<L, P, false>(this->n, this->labels);
		for (int i = 0; i < nc; i++)
		{
			Connection<P> co = C.Extract();
			if (!min_cop->connessi_id(co.id1, co.id2))
			{
				min_cop->add_connection(co.id1, co.id2, co.peso);
				min_cop->add_connection(co.id2, co.id1, co.peso);
			}
		}
		return min_cop;
	}
	strada<L, P>* Dijkstra(L start)
	{
		int s = this->get_id_from_label(start);
		if (s < 0)
			return nullptr;
		DijkstraHeap<P> H(this->n);
		DijkstraHeap<P>::swap(H.heap[0], H.heap[s]);
		H.Distanze[s].distanza = 0;
		H.Distanze[s].from_id = -1;
		for (int i = 0; i < this->n; i++)
			this->mark[i] = false;
		for (int i = 0; i < this->n; i++)
		{
			int k = H.Extract();
			this->mark[k] = true;
			if (H.Distanze[k].distanza == numeric_limits<P>::max())
				break;
			adiacenza* a = liste[k];
			while (a != nullptr)
			{
				if (!this->mark[a->id] && H.Distanze[a->id].distanza > H.Distanze[k].distanza + a->peso)
				{
					H.Distanze[a->id].distanza = H.Distanze[k].distanza + a->peso;
					H.Distanze[a->id].from_id = k;
					H.up(a->id);
				}
				a = a->next;
			}
		}
		strada<L, P>* st = new strada<L, P>[this->n];
		for (int i = 0; i < this->n; i++)
		{
			if (H.Distanze[i].from_id == -1)
			{
				st[i].lunghezza = 0;
			}
			if (H.Distanze[i].from_id >= 0)
			{
				st[i].lunghezza = H.Distanze[i].distanza;
				int t = H.Distanze[i].from_id;
				percorso<L>* p2 = nullptr;
				int k = 0;
				do
				{
					if (k == 0)
					{
						st[i].p = new percorso<L>(this->labels[t]);
						p2 = st[i].p;
						k++;
					}
					else
					{
						p2->next = new percorso<L>(this->labels[t]);
						p2 = p2->next;
					}
					t = H.Distanze[t].from_id;
				} while (t >= 0);
			}
		}
		return st;
	}
	void add_node(L label)
	{
		adiacenza** liste2 = new adiacenza*[this->n + 1];
		bool* mark2 = new bool[this->n + 1];
		L* labels2 = new L[this->n + 1];
		for (int i = 0; i < this->n; i++)
		{
			liste2[i] = liste[i];
			labels2[i] = this->labels[i];
		}
		delete[] liste;
		delete[] this->labels;
		delete[] this->mark;
		liste = liste2;
		this->labels = labels2;
		this->mark = mark2;
		liste[this->n] = nullptr;
		this->labels[this->n] = label;
		this->n++;
	}
	~Grafo_liste()
	{
		for (int i = 0; i < this->n; i++)
		{
			while (liste[i] != nullptr)
			{
				adiacenza* a = liste[i]->next;
				delete[] liste[i];
				liste[i] = a;
			}
			delete[] liste;
		}
	}
	void stampa()
	{
		for (int i = 0; i < this->n; i++)
		{
			cout << this->labels[i] << '\t';
			adiacenza* a = liste[i];
			while (a != nullptr)
			{
				cout << "-> " << this->labels[a->id] << " (" << a->peso << ") ";
				a = a->next;
			}
			cout << endl;
		}
	}
};

template<class L, class P, bool orientato>
class Grafo_matrice : public Grafo<L, P, orientato>
{
	P** conn;
	bool add_connection(int id, int to_id, P peso)
	{
		if (conn[id][to_id] == 0)
		{
			conn[id][to_id] = peso;
			return true;
		}
	}
	void visita_nodo(int id)
	{
		this->mark[id] = true;
		cout << this->labels[id] << endl;
		for (int i = 0; i < this->n; i++)
		{
			if (conn[id][i] != 0 && !this->mark[i])
				visita_nodo(i);
		}
	}
	bool mark_connections(int from_id, int to_id)
	{
		this->mark[from_id] = true;
		if (conn[from_id][to_id] != 0)
			return true;
		for (int i = 0; i < this->n; i++)
		{
			if (conn[from_id][i] != 0 && !this->mark[i])
				if (mark_connections(i, to_id))
					return true;
		}
		return false;
	}
	int get_n_connections()
	{
		int nc = 0;
		for (int i = 0; i < this->n; i++)
		{
			for (int ii = 0; ii < this->n; ii++)
			{
				if (conn[i][ii] > 0 && (i <= ii || orientato))
					nc++;
			}
		}
		return nc;
	}
	void get_connections(Connection_heap<P>& ch)
	{
		for (int i = 0; i < this->n; i++)
		{
			for (int ii = 0; ii < this->n; ii++)
			{
				if (conn[i][ii] > 0 && (i <= ii || orientato))
					ch.add_Connection(i, ii, conn[i][ii]);
			}
		}
		ch.Heapify();
	}
public:
	virtual void add_node(L label)
	{
		bool* mark2 = new bool[this->n + 1];
		L* labels2 = new L[this->n + 1];
		for (int i = 0; i < this->n; i++)
		{
			labels2[i] = this->labels[i];
		}
		delete[] this->labels;
		delete[] this->mark;
		this->mark = mark2;
		this->labels = labels2;
		this->labels[this->n] = label;
		P** conn2 = new P*[this->n + 1];
		for (int i = 0; i < this->n; i++)
		{
			conn2[i] = new P[this->n + 1];
			for (int ii = 0; ii < this->n; ii++)
				conn2[i][ii] = conn[i][ii];
			delete[] conn[i];
			conn2[i][this->n] = 0;
		}
		conn2[this->n] = new P[this->n + 1];
		for (int ii = 0; ii < this->n + 1; ii++)
			conn2[this->n][ii] = 0;
		delete[] conn;
		conn = conn2;
		this->n++;
	}
	Grafo_matrice(int l, const L* _labels) : Grafo<L, P, orientato>(l, _labels)
	{
		conn = new P*[this->n];
		for (int i = 0; i < this->n; i++)
		{
			conn[i] = new P[this->n];
			for (int ii = 0; ii < this->n; ii++)
			{
				conn[i][ii] = 0;
			}
		}
	}
	Grafo_matrice<L, P, false>* Kruskal()
	{
		if (orientato)
		{
			return nullptr;
			cout << "Kruskal funziona solo coi grafi non orientati";
		}
		int nc = get_n_connections();
		Connection_heap<P> C(nc);
		get_connections(C);
		Grafo_matrice<L, P, false>* min_cop = new Grafo_matrice<L, P, false>(this->n, this->labels);
		for (int i = 0; i < nc; i++)
		{
			Connection<P> co = C.Extract();
			if (!min_cop->connessi_id(co.id1, co.id2))
			{
				min_cop->add_connection(co.id1, co.id2, co.peso);
				min_cop->add_connection(co.id2, co.id1, co.peso);
			}
		}
		return min_cop;
	}
	~Grafo_matrice()
	{
		for (int i = 0; i < this->n; i++)
		{
			delete[] conn[i];
		}
		delete[] conn;
	};
	void stampa()
	{
		for (int i = 0; i < this->n; i++)
		{
			cout << this->labels[i] << '\t';
			for (int ii = 0; ii < this->n; ii++)
			{
				if (conn[i][ii])
					cout << "->" << this->labels[ii] << " (" << conn[i][ii] << ") ";
			}
			cout << endl;
		}
	}
};

void istruzioni()
{
	cout << endl << "Inserimento dei valori: e' possibile inserire i valori non interi sia come frazione, separando numeratore e denominatore da una barra (esempio: 7/5), oppure in formato decimale (esempio: 1.2), che verra' pero' convertito anch'esso in frazione" << endl;
	cout << endl << "Inserimento di un vettore: inserire le componenti del vettore racchiuse da parentesi quadre, separate da virgola (esempio: [2, 3, 7/3, -9])" << endl;
	cout << endl << "Inserimento di una matrice: inserire le varie righe della matrice come vettori, e racchiudere il tutto con ulteriori parentesi quadre, eventualmente anche andando a capo alla fine di ogni riga (esempio: [[7, 3, 2][8, 2, 1][9, 7/6, 9]])" << endl;
	cout << endl << "Funzionalita':" << endl;
	cout << endl << "1 = Simplesso primale: permette di risolvere un problema di ottimizzazione in formato primale standard data una base di partenza da inserire (inserire, quando richiesto, gli indici della base in ordine crescente separati da spazio)" << endl;
	cout << endl << "2 = Simplesso duale: permette di risolvere un problema di ottimizzazione in formato duale standard data una base di partenza da inserire (inserire, quando richiesto, gli indici della base in ordine crescente separati da spazio)" << endl;
	cout << endl << "3 = Problema primale: permette di risolvere un problema di ottimizzazione in formato primale standard senza conoscere una base ammissibile di partenza (verra' calcolata col problema ausiliario)" << endl;
	cout << endl << "4 = Problema duale: permette di risolvere un problema di ottimizzazione in formato duale standard senza conoscere una base ammissibile di partenza (verra' calcolata col problema ausiliario)" << endl;
	cout << endl << "5 = Passo del gradiente proiettato: svolge i calcoli per fare un passo dell'algoritmo del gradiente proiettato per massimi (per fare il minimo cambiare segno alla funzione obbiettivo) dato il poliedro, funzione obbiettivo e punto di partenza, non calcola tk, che va calcolato a mano dato dk" << endl;
	cout << endl << "6 = Passo di Frank Wolfe: svolge i calcoli per fare un passo dell'algoritmo di Frank Wolfe per massimi (per fare il minimo cambiare segno alla funzione obbiettivo), funzione obbiettivo e punto di partenza, non calcola tk, che va calcolato a mano dato dk e t cappuccio" << endl;
	cout << endl << "7 = Calcola gradiente funzioni quadratiche: dati i coefficienti di una funzione quadratica e un punto ne calcola il gradiente" << endl;
	cout << endl << "8 = Calcola un taglio di Gomory da problema primale: dato un problema in formato primale in cui le x sono tutte positive, e la soluzione ottima del rilassamento continuo, calcola un taglio di Gomory a scelta" << endl;
	cout << endl << "9 = Calcola tutti i tagli di Gomory da problema primale: dato un problema in formato primale in cui le x sono tutte positive, prova ad arrivare all'ottimo utilizzando tagli di Gomory (non sempre funziona, a volte sono necessari troppi passi!)" << endl;
	cout << endl << "10 = Simplesso primale + 1 taglio di Gomory: dato un problema in formato primale in cui le x sono tutte positive, lo risolve e calcola un taglio di Gomory a scelta" << endl;
}

int main()
{
	int k = 0;
	while (true)
	{
		cout << "0 = Istruzioni sull'uso del programma" << endl;
		cout << "1 = Simplesso primale" << endl;
		cout << "2 = Simplesso duale" << endl;
		cout << "3 = Problema primale" << endl;
		cout << "4 = Problema duale" << endl;
		cout << "5 = Passo del gradiente proiettato" << endl;
		cout << "6 = Passo di Frank Wolfe" << endl;
		cout << "7 = Calcola gradiente funzioni quadratiche" << endl;
		cout << "8 = Calcola un taglio di Gomory da problema primale" << endl;
		cout << "9 = Calcola tutti i tagli di Gomory da problema primale" << endl;
		cout << "10 = Simplesso primale + 1 taglio di Gomory" << endl;
		cout << "Numero negativo per uscire" << endl;
		cin >> k;
		cout << endl;
		if (k == 0)
			istruzioni();
		else if (k == 1)
			simplesso_primale<frac>();
		else if (k == 2)
			simplesso_duale<frac>();
		else if (k == 3)
			problema_PL_primale<frac>();
		else if (k == 4)
			problema_PL_duale<frac>();
		else if (k == 5)
			passo_gradiente_proiettato<frac>();
		else if (k == 6)
			passo_di_frank_wolfe<frac>();
		else if (k == 7)
			calcola_gradiente_quadratiche<frac>();
		else if (k == 8)
			taglio_di_gomory<frac>();
		else if (k == 9)
			tagli_di_gomory<frac>();
		else if (k == 10)
			simplesso_gomory<frac>();
		else if (k < 0)
			return 0;
		cout << endl;
		fflush(stdin);
		cin.clear();
		cin.ignore(9999, '\n');
	}
}