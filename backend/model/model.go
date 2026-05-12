package model

// Tipe FSM untuk status makanan
type StatusMakanan string

const (
	StatusTersedia     StatusMakanan = "tersedia"
	StatusDirequest    StatusMakanan = "direquest"
	StatusDidistribusi StatusMakanan = "didistribusikan"
	StatusKadaluarsa   StatusMakanan = "kadaluarsa"
)

func (s StatusMakanan) CanTransitionTo(next StatusMakanan) bool {
	allowed, ok := validTransitions[s]
	if !ok {
		return false
	}
	for _, a := range allowed {
		if a == next {
			return true
		}
	}
	return false
}

// Tipe FSM untuk status request
type StatusRequest string

const (
	StatusPending   StatusRequest = "pending"
	StatusDisetujui StatusRequest = "disetujui"
	StatusDitolak   StatusRequest = "ditolak"
	StatusSelesai   StatusRequest = "selesai"
)

func (s StatusRequest) CanTransitionTo(next StatusRequest) bool {
	allowed, ok := validRequestTransitions[s]
	if !ok {
		return false
	}
	for _, a := range allowed {
		if a == next {
			return true
		}
	}
	return false
}

// Tabel transisi valid untuk status makanan
var validTransitions = map[StatusMakanan][]StatusMakanan{
	StatusTersedia:     {StatusDirequest, StatusKadaluarsa},
	StatusDirequest:    {StatusDidistribusi, StatusTersedia},
	StatusDidistribusi: {},
	StatusKadaluarsa:   {},
}

// Tabel transisi valid untuk status request
var validRequestTransitions = map[StatusRequest][]StatusRequest{
	StatusPending:   {StatusDisetujui, StatusDitolak},
	StatusDisetujui: {StatusSelesai},
	StatusDitolak:   {},
	StatusSelesai:   {},
}
