/// <summary>
/// Enum Seminar Journal Entry Type (ID 50003).
/// </summary>
enum 50003 "Seminar Journal Entry Type"
{
    Extensible = true;

    value(0; Registration)
    {
        Caption = 'Registration';
    }
    value(1; Cancellation)
    {
        Caption = 'Cancellation';
    }
}
