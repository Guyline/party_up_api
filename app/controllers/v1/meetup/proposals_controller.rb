class V1::Meetup::ProposalsController < V1::Meetup::BaseController
  include V1::Concerns::HandlesProposals

  def create
    @proposal = Proposal.create!(proposal_params.merge(proposer: current_user))
    render json: ProposalSerializer.new(@proposal).serializable_hash
  end

  protected

  def index_query
    meetup.proposals
  end
end
