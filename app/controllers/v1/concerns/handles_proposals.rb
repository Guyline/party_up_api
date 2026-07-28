module V1::Concerns::HandlesProposals
  extend ActiveSupport::Concern

  included do
    protected

    def proposal_params
      params.require(:data)
        .require(:attributes)
        .permit(
          :familiarity,
          :priority,
          :proposer_notes
        )
    end

    def valid_includes
      {}
    end

    def serializer
      ProposalSerializer
    end
  end
end
