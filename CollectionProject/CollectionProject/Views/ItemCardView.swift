import SwiftUI

struct ItemCardView: View {
    let item: Item
    
    var body: some View {
        VStack {
            Image(systemName: "photo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 100)
                .cornerRadius(8)
                .padding(.bottom, 8)
            
            Text(item.title)
                .font(.headline)
                .lineLimit(1)
                .truncationMode(.tail)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
            
            Text(NSLocalizedString(item.category.rawValue, comment: "Category name"))
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Text(NSLocalizedString(item.status.rawValue, comment: "Status"))
                .font(.caption)
                .foregroundColor(item.status == .available ? .green : .red)
                .padding(.top, 4)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 4)
        .frame(maxWidth: .infinity)
    }
}