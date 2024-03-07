/// <summary>
/// Enum Custom Approval Status (ID 50007).
/// </summary>
enum 50007 "Custom Approval Status"
{
    Extensible = true;

    value(0; Open)
    {
        Caption = 'Open';
    }
    value(1; "Pending Approval")
    {
        Caption = 'Pending Approval';
    }
    value(2; Rejected)
    {
        Caption = 'Rejected';
    }
    value(3; Released)
    {
        Caption = 'Released';
    }
}
