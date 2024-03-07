/// <summary>
/// Enum Seminar Registration Status (ID 50001).
/// </summary>
enum 50001 "Seminar Registration Status"
{
    Extensible = true;

    value(0; Planning)
    {
        Caption = 'Planning';
    }
    value(1; Registration)
    {
        Caption = 'Registration';
    }
    value(2; Closed)
    {
        Caption = 'Closed';
    }
    value(3; Cancelled)
    {
        Caption = 'Cancelled';
    }
}
