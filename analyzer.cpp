#include "analyzer.hpp"

Analyzer::Analyzer(QObject *parent)
    : QObject(parent)
{}

QString Analyzer::getResult() const { return result; }

void Analyzer::reset() { secret.reset(); }

void Analyzer::input(const QString &input) {

    QByteArray digits = input.toLatin1();

    if ( static_cast<size_t> (digits.size()) != secret.size() )
        throw std::invalid_argument("invalid input");

    std::vector<char> checked_digits;

    uint bulls = getBulls(digits, checked_digits);

    uint cows = getCows(digits, checked_digits);

    result = QString::number(bulls) + "B" + QString::number(cows) + "C";

    emit analyzed();

    if (bulls == secret.size()) emit guessed();
}
uint Analyzer::getBulls(const QByteArray &digits, std::vector<char> &checked_digits) {

    uint bulls = 0;

    for (unsigned i = 0; i < static_cast<unsigned> ( digits.size() ); ++i)
    {
        if (digits[i] == secret[i]) {

            ++bulls;

            checked_digits.push_back(digits[i]);
        }
    }

    return bulls;
}
uint Analyzer::getCows(const QByteArray &digits, std::vector<char> &checked_digits) {

    uint cows = 0;

    for (int i = 0; i < digits.size(); ++i) {

        if (isChecked(digits[i],checked_digits)) continue;

        for (unsigned j = 0; j < secret.size(); ++j) {

            if (digits[i] == secret[j]) {

                ++cows;

                checked_digits.push_back(digits[i]);

                break;
            }
        }
    }
    return cows;
}
bool Analyzer::isChecked(const char &digit, std::vector<char> &checked_digits) {

    bool checked = false;

    for (char const &x : checked_digits) {

        if (digit == x) {

            checked = true;

            break;
        }
    }

    return checked;
}
