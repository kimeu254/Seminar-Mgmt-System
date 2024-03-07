/// <summary>
/// Table Seminar Cue (ID 50012).
/// </summary>
table 50012 "Seminar Cue"
{
    Caption = 'Seminar Cue';
    ReplicateData = false;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(2; Planned; Integer)
        {
            Caption = 'Planned';
            FieldClass = FlowField;
            CalcFormula = Count("Seminar Registration Header" WHERE(Status = CONST(Planning)));
        }
        field(3; Registered; Integer)
        {
            Caption = 'Registered';
            FieldClass = FlowField;
            CalcFormula = Count("Seminar Registration Header" WHERE(Status = CONST(Registration)));
        }
        field(4; Closed; Integer)
        {
            Caption = 'Closed';
            FieldClass = FlowField;
            CalcFormula = Count("Seminar Registration Header" WHERE(Status = CONST(Closed)));
        }
    }
    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }
}