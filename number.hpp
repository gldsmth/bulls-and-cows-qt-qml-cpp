#pragma once

#include <vector>

class SecretNumber
{
public:
    explicit SecretNumber(const uint8_t &number_of_digits = 4);

    SecretNumber(const SecretNumber&) = delete;

    size_t size() const noexcept;

    void reset();

    auto begin() noexcept;
    auto end()   noexcept;
    auto begin() const noexcept;
    auto end()   const noexcept;

    char& operator [](const unsigned&);

private:
    std::vector<char> digits;
};
