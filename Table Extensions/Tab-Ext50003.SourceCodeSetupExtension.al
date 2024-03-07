/// <summary>
/// TableExtension Source Code Setup Extension (ID 50003) extends Record Source Code Setup.
/// </summary>
tableextension 50003 "Source Code Setup Extension" extends "Source Code Setup"
{
    fields
    {
        field(50000; Seminar; Code[10])
        {
            Caption = 'Seminar';
            DataClassification = CustomerContent;
            TableRelation = "Source Code";
        }
    }
}
