module Processing
  class AgencyWorks
    class NoteTextExtractor
      def extract_note_text(status)
        case status
        when "App. Submitted"
          37
        when "Approved"
          5
        when "Approved Other than Applied"
          9
        when "Await Funds/1035 Exchange"
          71
        when "Declined"
          17
        when "Deceased"
          39
        when "Holding"
          73
        when "In Force"
          63
        when "Issued - Del. Req."
          11
        when "Not Taken"
          20
        when "Postponed"
          15
        when "Reissued Case"
          41
        when "Tentative Offer"
          70
        when "Rated Rejected"
          23
        end
      end
    end
  end
end
