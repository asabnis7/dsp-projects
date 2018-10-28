// Arjun Sabnis
// Constant Q-transform spectrum analyzer implementation
// 10-27-2018

#include "spectra.h"

// Notes for visualization ####################################################
std::string notes[12] = {"A", "A#", "B", "C",
                        "C#", "D", "D#", "E",
                        "F", "F#", "G", "G#"};

// Octave struct implementation ###############################################     
Octave::Octave(double bs, int num):
    baseNote(bs),
    numNotes(num)
{
    noteFreqs = new double[num];
    for(int i = 0; i < num; i++) noteFreqs[i] = 440.0*pow(2,((i+bs-49)/12));
}

Octave::~Octave(){ delete[] noteFreqs; }

double Octave::getFreq(int index){ return noteFreqs[index]; }

void Octave::print()
{
    for(int i = 0; i < numNotes; i++) std::cout << noteFreqs[i] << std::endl;
}
    
// End Octave implementation ##################################################


// Complex struct implementation ##############################################
Complex::Complex(): 
    real(0.0), 
    imag(0.0), 
    angle(0.0), 
    mag(0.0) { }

Complex::Complex(double i)
{
    real = cos(i);
    imag = sin(i);
    eulerCalc(); 
}

Complex::Complex(double re, double im)
{
    real = re;
    imag = im;
    eulerCalc();
}           

void Complex::eulerCalc()
{
    mag = sqrt(pow(real,2)+pow(imag,2));
    angle = atan2(imag,real);
}

void Complex::cartCalc()
{
    real = mag*cos(angle);
    imag = mag*sin(angle);
}

void Complex::setCart(double r, double i)
{
    real = r;
    imag = i;
    eulerCalc();
}

void Complex::setEuler(double m, double a)
{
    mag = m;
    angle = a;
    cartCalc();
}

double Complex::getReal() const { return real; }
double Complex::getImag() const { return imag; }
double Complex::getMag() const { return mag; }
double Complex::getAngle() const { return angle; }

void Complex::print()
{
    std::cout << real << " + " << imag << "i" << std::endl;
    std::cout << mag << "e^i" << angle << std::endl;
}

Complex & Complex::operator*(const double rhs)
{
    this->real *= rhs;
    this->imag *= rhs;
    eulerCalc();
    return *this;
}

Complex & Complex::operator+(const Complex& rhs)
{
    this->real += rhs.real;
    this->imag += rhs.imag;
    eulerCalc();
    return *this;
}

Complex & Complex::operator/(const double rhs)
{
    this->real /= rhs;
    this->imag /= rhs;
    eulerCalc();
    return *this;
}

Complex & operator*(const double lhs, Complex& rhs)
{   
    rhs.real *= lhs;
    rhs.imag *= lhs;
    rhs.eulerCalc();
    return rhs;
}

// End Complex implementation #################################################


// Hamming window function ####################################################

double * hamming(int length)
{
    double * window = new double[length];

    for(double n = 0; n < length; n++) 
        window[int(n)] = 0.54-0.46*cos(2*pi*(n/(length-1)));

    return window;
}

// End hamming ################################################################


// QFT Implementation #########################################################

qTransform::qTransform(double samp, double fund, double max, int b):
    fs(samp),
    fo(fund),
    fmax(max),
    bins(b),
    maxMag(0.0)
{
    Q = 1.0/(pow(2,1.0/(double)b)-1.0);          
    K = b*ceil(log2(max/fund));
    N = (Q*samp)/(fund*pow(2,(K/b)));
    cq = new Complex[(int)K];
    for (int i = 0; i < (int)K; i++) cq[i] = Complex();
}
        
qTransform::~qTransform(){ delete[] cq; }

Complex * qTransform::getValues() { return cq; }    
int qTransform::getK() const { return (int)K; }
int qTransform::getN() const { return N; }

void qTransform::QFT(double * signal)
{
    clear();
    for (double k = 0; k < (int)K; k++)
    {
        N = (Q*fs)/(fo*pow(2,(k/bins)));
        double * window = hamming(N);
        for (int n = 0; n < N; n++)
        {
            Complex ewt(-2*pi*Q*n/N);
            cq[(int)k] = cq[(int)k] + (signal[n]*(window[n]*ewt)/N);
        }
    }
    cqNormalize();
}

void qTransform::cqNormalize()
{
    for (int i = 0; i < (int)K; i++) maxMag = std::max(maxMag, cq[i].getMag());
    for (int k = 0; k < (int)K; k++) cq[(int)k] = cq[(int)k]/maxMag;
}

void qTransform::clear()
{
    for (int i = 0; i < (int)K; i++) cq[i].setCart(0.0,0.0);
    maxMag = 0;
}

void qTransform::printMag()
{
    std::cout << "Spectrum ----------------" << std::endl;
    for (int i = 0; i < (int)K; i++) 
        std::cout << notes[i] << ":  " << cq[i].getMag() << std::endl;
    std::cout << "-------------------------" << std::endl;
}

void qTransform::graphSpectrum()
{
    double mag = 0.0;

    std::cout << "\rSpectrum ----------------\n";
    for (int i = 0; i < (int)K; i++)
    {
        mag = cq[i].getMag();

        if (mag >= 0.0 && mag < 0.1)
            std::cout << "\r" << std::setw(3) << notes[i] << " *\n";
        else if (mag >= 0.1 && mag < 0.2)
            std::cout << "\r" << std::setw(3) << notes[i] << " **\n";
        else if (mag >= 0.2 && mag < 0.3)
            std::cout << "\r" << std::setw(3) << notes[i] << " ***\n";
        else if (mag >= 0.3 && mag < 0.4)
            std::cout << "\r" << std::setw(3) << notes[i] << " ****\n";
        else if (mag >= 0.4 && mag < 0.5)
            std::cout << "\r" << std::setw(3) << notes[i] << " *****\n";
        else if (mag >= 0.5 && mag < 0.6)
            std::cout << "\r" << std::setw(3) << notes[i] << " ******\n";
        else if (mag >= 0.6 && mag < 0.7)
            std::cout << "\r" << std::setw(3) << notes[i] << " *******\n";
        else if (mag >= 0.7 && mag < 0.8)
            std::cout << "\r" << std::setw(3) << notes[i] << " ********\n";
        else if (mag >= 0.8 && mag < 0.9)
            std::cout << "\r" << std::setw(3) << notes[i] << " *********\n";
        else if (mag >= 0.9 && mag < 1.0)
            std::cout << "\r" << std::setw(3) << notes[i] << " **********\n";
        else 
            std::cout << "\r" << std::setw(3) << notes[i] << " ***********\n";
    }
    std::cout << "\r-------------------------\n";
}
// End QFT implementation #####################################################
