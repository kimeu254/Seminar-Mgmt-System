/// <summary>
/// Enum Seminar Journal Charge Type (ID 50004).
/// </summary>
enum 50004 "Seminar Journal Charge Type"
{
    Extensible = true;

    value(0; Instructor)
    {
        Caption = 'Instructor';
    }
    value(1; Room)
    {
        Caption = 'Room';
    }
    value(2; Participant)
    {
        Caption = 'Participant';
    }
    value(3; Charge)
    {
        Caption = 'Charge';
    }
}
