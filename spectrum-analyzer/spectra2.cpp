#include <iostream>
#include <cstdlib>
#include <cmath>
#include <iomanip>
#include <string>

using namespace std;

#define pi 3.1415926

string notes[12] = {"A" "A#" "B" "C" "C#" "D" "D#" "E" "F" "F#" "G" "G#"};


class Octave{
    private:  
        double base;
        int numNotes;
        double * freqs;

    public:
        
        Octave(int num){
            base = 25;
            numNotes = num;
            freqs = new double[numNotes];
        }
        
        ~Octave()
        {
            delete[] freqs;
        }

        void createOctave(){
            for(int f = 0; f < numNotes; f++){
                freqs[f] = 440.0*pow(2,((f+base-49)/12));;
            }
        }
        
        double getFreq(int index){ return freqs[index]; }

        void print(){
            for(int i = 0; i < numNotes; i++){
                cout << freqs[i] << endl;
            }
        }
};



class Complex{
    private:
        double real, imag, angle, mag;

    public:
        Complex(): real(0.0), imag(0.0), angle(0.0), mag(0.0) { }

        Complex(double i)
        {
            real = cos(i);
            imag = sin(i);
            eulerCalc(); 
        }

        Complex(double re, double im)
        {
            real = re;
            imag = im;
            eulerCalc();
        }           

        void eulerCalc()
        {
            mag = sqrt(pow(real,2)+pow(imag,2));
            angle = tan(imag/real);
        }

        void cartCalc()
        {
            real = mag*cos(angle);
            imag = mag*sin(angle);
        }

        double getRe() const { return real; }
        double getIm() const { return imag; }
        void setCart(double r, double i) { real = r; imag = i; eulerCalc(); }

        double getMag() const { return mag; }
        double getAngle() const { return angle; }
        void setEuler(double m, double a) { mag = m; angle = a; cartCalc(); }

        void print() {
            cout << real << " + " << imag << "i" << endl;
            cout << mag << "e^i" << angle << endl;
        }

        friend Complex & operator*(double lhs, Complex& rhs);
        
        Complex & operator*(double rhs)
        {
            real *= rhs;
            imag *= rhs;
            eulerCalc();
            return *this;
        }

        Complex & operator+(Complex& c1)
        {
            real += c1.real;
            imag += c1.imag;
            eulerCalc();
            return *this;
        }

        Complex & operator/(double rhs)
        {
            real /= rhs;
            imag /= rhs;
            eulerCalc();
            return *this;
        }
};

Complex & operator*(double lhs, Complex& rhs)
{   
    rhs.real *= lhs;
    rhs.imag *= lhs;
    rhs.eulerCalc();
    return rhs;
}

double * hamming(int length){

    double * window = new double[length];

    for(double n = 0; n < length; n++){
        window[int(n)] = 0.54-0.46*cos(2*pi*(n/(length-1)));
        // cout << setprecision(3) << window[int(n)] << endl;
    }

    return window;
}


class qTransform{
    private:
        double fs, fo, fmax, Q, K;
        int bins;
        Complex * cq;

    public:
        qTransform(double samp, double fund, double max){
            fs = samp;
            fo = fund;
            fmax = max;
            bins = 12;

            Q = 1.0/(pow(2,1.0/bins)-1.0);          
            K = ceil(bins*log2(fmax/fo));
            
            cq = new Complex[(int)K];
            for (int i = 0; i < (int)K; i++) cq[i] = Complex();
        }
        
        ~qTransform()
        {
            delete[] cq;
        }

        Complex * getValues() { return cq; }
        
        int getK() { return (int)K; }

        void qTransCalc(double signal[], int sigSize)
        {
            for (int g = 0; g < sigSize-1000; g += 800)
            {
                for (double k = 0; k < (int)K; k++)
                {
                    int N = (Q*fs)/(fo*pow(2,(k/bins)));

                    double * window = hamming(N);

                    for (int n = 0; n < N; n++)
                    {
                        Complex c1 = Complex(-2*pi*Q*n/N);
                        cq[(int)k] = cq[(int)k] + (signal[n+g]*(window[n]*c1)/N);
                    }

                }
            }
        }
};


int main()
{
    Octave oct1(12);
    oct1.createOctave();
    // oct1.print();
    // double * hamm = hamming(11);
    
    double signal[10000];
    int sigSize = sizeof(signal)/sizeof(signal[0]);
    for (int i = 0; i < sigSize; i++) signal[i] = sin(2*pi*120*(0.01*i));
        
    qTransform spectrum(8192,oct1.getFreq(0), oct1.getFreq(11));
    spectrum.qTransCalc(signal, sigSize);
    
    Complex * cq = spectrum.getValues();
    int Ksize = spectrum.getK();

    for (int j = 0; j < Ksize; j++) cq[j].print();

    /*
    Complex c1(1,1);
    double d1 = 2.0;
    c1.print();
    c1 = c1*d1;
    c1.print();
    c1 = d1*c1;
    c1.print();
    c1 = c1+c1;
    c1.print();
    Complex c2(pi*3.4);
    c2.print();
    c1 = c1 + c2;
    c1.print();
    */

}
