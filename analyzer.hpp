#pragma once

#include <QObject>
#include <QString>
#include <number.hpp>

class Analyzer : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString result READ getResult)
public:
    explicit Analyzer(QObject *parent = nullptr);

    QString getResult() const;

    Q_INVOKABLE void input(const QString&);
    Q_INVOKABLE void reset();

signals:
    void analyzed();
    void guessed();

private:
    static bool isChecked(char const &, std::vector<char> &);

    uint getBulls(QByteArray const &, std::vector<char> &);
    uint getCows(QByteArray const &, std::vector<char> &);

    SecretNumber secret;
    QString result;
};
