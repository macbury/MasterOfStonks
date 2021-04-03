ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: proc { I18n.t("active_admin.dashboard") }

  content title: proc { I18n.t("active_admin.dashboard") } do
    percentages, amounts = Stats::WalletComposition.call
    columns do
      column do
        panel "Kompozycja portfela" do  
          pie_chart(percentages, suffix: "%", legend: 'left')
        end
      end
      column do
        panel "Kompozycja szczegóły" do
          table_for amounts do
            column(:name)
            column(:amount) { |a| a[:amount].format }
            column(:percentage) { |a| "#{a[:percentage]} %" }
          end
        end

        panel "Wartość rynkowa" do
          h2 amounts.map { |a| a[:amount] }.sum.format
        end

        panel "Wartość dodana" do
          h2 Stats::NetTotalSum.call(Time.zone.today).format
        end
      end
    end
    columns do
      column width: '100%' do
        tabs do
          tab "Net value monthly" do
            line_chart Stats::NetValue.call(from: 1.month.ago), suffix: ' zł', thousands: ",", decimal: '.'
          end
        
          tab "Net quarterly" do
            line_chart Stats::NetValue.call(from: 3.months.ago), suffix: ' zł', thousands: ",", decimal: '.'
          end

          tab "Net yearly" do
            line_chart Stats::NetValue.call(from: 1.year.ago), suffix: ' zł', thousands: ",", decimal: '.'
          end
        end
      end
    end
  end # content
end
