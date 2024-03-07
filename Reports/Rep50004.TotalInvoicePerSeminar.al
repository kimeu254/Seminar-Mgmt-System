report 50004 "Total Invoice Per Seminar"
{
    ApplicationArea = All;
    Caption = 'Income Per Seminar';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/IncomePerSeminar.rdl';

    dataset
    {
        dataitem(SeminarRegistrationHeader; "Seminar Registration Header")
        {
            column(No; "No.")
            {
            }
            column(SeminarNo; "Seminar No.")
            {
            }
            column(SeminarName; "Seminar Name")
            {
            }
            column(SeminarPrice; "Seminar Price")
            {
            }
            column(TotalPriceToInvoice; "Total Price (To Invoice)")
            {
            }
            column(CompanyName; CompanyInfo.Name)
            {
            }
            column(CompanyAddress; CompanyInfo.Address)
            {
            }
            column(CompanyAddress2; CompanyInfo."Address 2")
            {
            }
            column(CompanyPicture; CompanyInfo.Picture)
            {
            }
            column(CompanyEmail; CompanyInfo."E-Mail")
            {
            }
            column(NoParticipants; NoParticipants)
            {
            }

            trigger OnAfterGetRecord()
            begin
                NoParticipants := 0;

                SeminarRegLine.Reset();
                SeminarRegLine.SetRange("Document No.", "No.");
                if SeminarRegLine.FindSet() then
                    NoParticipants := SeminarRegLine.Count;
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(processing)
            {
            }
        }
    }

    trigger OnPreReport()
    begin
        CompanyInfo.Get();
        FormatAddr.Company(CompanyAddr, CompanyInfo);
        CompanyInfo.CalcFields(Picture);
    end;

    var
        CompanyInfo: Record "Company Information";
        FormatAddr: Codeunit "Format Address";
        SeminarRegLine: Record "Seminar Registration Line";
        CompanyAddr: array[8] of Text[100];
        NoParticipants: Integer;
}
