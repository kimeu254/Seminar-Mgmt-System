/// <summary>
/// TableExtension Resource Tbl Ext (ID 50000) extends Record Resource.
/// </summary>
tableextension 50000 "Resource Tbl Ext" extends Resource
{
    fields
    {
        field(50000; "Internal/External"; Option)
        {
            Caption = 'Internal/External';
            DataClassification = ToBeClassified;
            OptionMembers = Internal,External;
        }
        field(50001; "Maximum Participants"; Integer)
        {
            Caption = 'Maximum Participants';
            DataClassification = ToBeClassified;
        }
    }

    /// <summary>
    /// IsRoom.
    /// </summary>
    /// <returns>Return value of type Boolean.</returns>
    procedure IsRoom(): Boolean
    begin
        exit(Type = Type::Machine);
    end;

    /// <summary>
    /// IsInstructor.
    /// </summary>
    /// <returns>Return value of type Boolean.</returns>
    procedure IsInstructor(): Boolean
    begin
        exit(not IsRoom());
    end;
}
